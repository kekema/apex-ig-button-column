/**
 * @author Karel Ekema
 * @license MIT license
 * Copyright (c) 2025 Karel Ekema
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the 'Software'), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

window.lib4x = window.lib4x || {};
window.lib4x.axt = window.lib4x.axt || {};
window.lib4x.axt.ig = window.lib4x.axt.ig || {};

/* ButtonColumn
 * Plugin enabling a button column in IG. DA's can be attached or an action can
 * be specified (from action framework) for any button click follow up. 
 * There is support for conditional enabling and for button label/class substitution,
 * based on the row data.
 * 
 * When making use of conditional enabling of buttons, it is important to have the
 * column Source Type as 'None'. So the column won't have any values. Reasons is, when
 * a button is disabled, any button column value won't be submitted upon a row save,
 * resulting in a Session State Violation error in case initially there was a value.
 */
lib4x.axt.ig.buttonColumn = (function($, util) {

    const C_IG = 'a-IG';
    const C_COLUMN_ITEMS_CONTAINER = 'a-GV-columnItemContainer';
    const C_IG_RECORD_VIEW = 'a-IG-recordView';

    let pluginUtil = {
        // evaluates the given columnValue against the condition type and value
        evaluateCondition: function(condition, columnValue)
        {
            const { type, value } = condition;

            // attempt numeric conversion if both are stringy numbers
            const leftNum = Number(columnValue);
            const rightNum = Number(value);
            const bothAreNumeric = columnValue && value && !isNaN(leftNum) && !isNaN(rightNum);
            const left = bothAreNumeric ? leftNum : columnValue;
            const right = bothAreNumeric ? rightNum : value;
          
            switch (type) {
              case 'EQUAL':
                return left === right;
              case 'NOT_EQUAL':
                return left !== right;
              case 'LESS':
                return left < right;
              case 'LESS_EQUAL':
                return left <= right;
              case 'GREATER':
                return left > right;
              case 'GREATER_EQUAL':
                return left >= right;
              case 'NULL':
                return left === null || left === undefined || left === '';
              case 'NOT_NULL':
                return left !== null && left !== undefined && left !== '';
              default:
                throw new Error(`Unknown condition type: ${type}`);
            }
        }
    }

    // model utility functions
    let modelUtil = {
        getFieldMetadata: function(recMetadata, fieldName, createIfNotExists)
        {
            let result = null;
            if (recMetadata)
            {
                if (!recMetadata.fields)
                {
                    if (createIfNotExists)
                    {
                        recMetadata.fields = {};
                    }
                }
                let fieldsMetadata = recMetadata.fields;
                if (fieldsMetadata)
                {
                    if (!fieldsMetadata[fieldName])
                    {
                        if (createIfNotExists)
                        {
                            fieldsMetadata[fieldName] = {};
                        }
                    }
                    result = fieldsMetadata[fieldName];
                }
            } 
            return result;           
        },
        getFieldMetaPropertyValue: function(recMetadata, fieldName, metaProperty)
        {
            let result = null;
            let fieldMetadata = this.getFieldMetadata(recMetadata, fieldName, false);
            if (fieldMetadata)
            {
                result = fieldMetadata[metaProperty];
            }
            return result;
        },
        setFieldMetaPropertyValue: function(model, recordId, recMetadata, fieldName, metaProperty, value)
        {
            if (recMetadata)
            {
                if (!recMetadata.fields)
                {
                    recMetadata.fields = {};
                }
                let fieldsMetadata = recMetadata.fields;
                if (!fieldsMetadata[fieldName])
                {
                    fieldsMetadata[fieldName] = {};
                }
                fieldsMetadata[fieldName][metaProperty] = value;
                model.metadataChanged(recordId, fieldName, metaProperty); 
            } 
        },
        getScalarValue: function(model, record, property)
        {
            let value = model.getValue(record, property);
            if (value !== null && typeof value === "object" && value.hasOwnProperty( "v" ))
            {
                value = value.v;
                if (Array.isArray(value))
                {
                    let modelFields = model.getOption("fields");
                    let modelField = modelFields[property];
                    let separator = ':';
                    if (modelField && modelField.elementId && apex.item(modelField.elementId).getSeparator)
                    {
                        separator = apex.item(modelField.elementId).getSeparator();
                        if (!separator)
                        {
                            separator = ":";
                        }
                    }
                    value = value.join([separator = separator]);
                }
            }
            return value;
        },
        getNativeValue: function(model, record, property)
        {
            let value = this.getScalarValue(model, record, property);
            let nativeValue = value;
            let modelFields = model.getOption("fields");
            let modelField = modelFields[property];
            let dataType = modelField.dataType;
            if (dataType == 'NUMBER')
            {
                if (value)
                {
                    nativeValue = apex.locale.toNumber(value, modelField.formatMask);
                }
                else
                {
                    nativeValue = null;
                }
            }
            else if (dataType == 'DATE')
            {
                nativeValue = null;
                if (value)
                {        
                    try
                    {
                        nativeValue = apex.date.parse(value, modelField.formatMask);
                    }
                    catch(error) 
                    {
                        console.log('Invalid date: ' + value);
                    }
                    if (nativeValue)
                    {
                        // nativeValue = nativeValue.toISOString();  // this gives a UTC date. Eg: 2024-01-26T12:00:00Z
                        // DATE type in Oracle has no timezone info, so we send parsed date as-is, same as IG is sending upon save
                        nativeValue = apex.date.toISOString(nativeValue);   // ISO string without timezone. Eg: 2024-01-26T13:00:00
                    }
                }
                else
                {
                    nativeValue = null;
                }
            }
            return nativeValue;
        },
        setFieldDisabled: function(model, recordId, recMetadata, fieldName, disabled)
        {
            this.setFieldMetaPropertyValue(model, recordId, recMetadata, fieldName, 'disabled', disabled);
        },
        isRecordField: function(modelField)
        {
            return (modelField.hasOwnProperty('index') && modelField.property != '_meta');  // model.getOption('metaField')
        },          
        recordArrayToObject: function(model, record)
        {
            let recordObject = null;
            let modelFields = model.getOption("fields");
            if (record && modelFields)
            {
                recordObject = {};
                for (const [fieldName, modelField] of Object.entries(modelFields))
                {  
                    if (this.isRecordField(modelField))
                    {
                        recordObject[fieldName] = this.getNativeValue(model, record, fieldName);
                    }
                }
            }
            return recordObject;
        }     
    };

    // Init the item - will be called on page load
    // In the init here, the specific item interface is set up by applying apex.item.create.
    // Client-side, the html for the button is generated.
    let init = function(itemId, buttonColumnName, columnLabel, options, enableCondition)
    { 
        const substPattern = /&[^.]*\./;    // pattern &XXXX. as used for substitutions

        let index = 0;  // used to generate unique button id's 
        let labelSubst = substPattern.test(options.label);
        let classSubst = substPattern.test(options.cssClasses);

        let typeClass = {};
        typeClass['NORMAL'] = null;
        typeClass['PRIMARY'] = 't-Button--primary';
        typeClass['WARNING'] = 't-Button--warning';
        typeClass['DANGER'] = 't-Button--danger';
        typeClass['SUCCESS'] = 't-Button--success';

        // compose button/span classes
        let buttonClass = null;
        let spanIconClass = null;
        if (options.appearance == 'ICON')
        {
            buttonClass = 't-Button t-Button--noLabel  t-Button--icon t-Button--small';
            spanIconClass = 't-Icon ' + options.iconClass;
        }
        else if (options.appearance == 'TEXT_WITH_ICON')
        {
            buttonClass = 't-Button t-Button--icon t-Button--small t-Button--iconLeft';
            spanIconClass = 't-Icon t-Icon--left ' + options.iconClass;
        }
        else // 'TEXT'
        {
            buttonClass = 't-Button t-Button--small';
        }
        buttonClass = buttonClass + (typeClass[options.type] ? ' ' + typeClass[options.type] : '');
        buttonClass = buttonClass + (options.cssClasses ? ' ' + options.cssClasses : '');

        // compose buttonStyle
        let buttonStyle = null;
        if (options.width == 'STRETCH')
        {
            buttonStyle = 'display: block; width: 100%;';
        }
        else if (options.width == 'PIXELS')
        {
            buttonStyle = 'width: ' + options.widthPixels + 'px;'
        }

        // the server-side generated hidden input element will never be swapped into the IG as
        // it is a read-only column
        const item$ = $(`#${itemId}`);
        const ig$ = item$.closest('.' + C_COLUMN_ITEMS_CONTAINER).closest("div[id$='_ig']");

        // function to render the button
        // the rendering is from displayValueFor in the item interface
        // as to render for each and every row
        const renderButton = (value, renderDisabled) => {
            let gridView = getGridView();
            let singleRowMode = !!gridView.singleRowMode;
            let recordId = null;
            if (singleRowMode)
            {
                recordId = gridView.singleRowView$.recordView('instance').currentRecordId;     
                if (recordId && !renderDisabled)
                {
                    let recMetadata = gridView.model.getRecordMetadata(recordId);
                    // SRV is not properly setting the is-readonly class on the container during insert mode
                    // upon field deactivate, it executes a setValue which will error
                    // to prevent, we keep it disabled
                    renderDisabled =  (!!recMetadata?.inserted);
                }
            }       
            let rLabel = options.label || value;
            let rButtonClass = buttonClass;
            // for SingleRowView, we can do substitutions over here as the record is known            
            if (singleRowMode && recordId && (labelSubst || classSubst))
            {
                let templateOptions = {model: gridView.model, record: gridView.model.getRecord(recordId)};
                if (labelSubst)
                {
                    rLabel = apex.util.applyTemplate(rLabel, templateOptions);
                }
                if (classSubst)
                {
                    rButtonClass = apex.util.applyTemplate(rButtonClass, templateOptions);
                }
            }
            if (!rLabel)
            {
                rLabel = columnLabel;
            }
            // build the button html
            const out = util.htmlBuilder();     
            out.markup('<div')
                .attr('class', 'lib4x-column-button')
                .markup('><button')
                .optionalAttr('style', !singleRowMode ? buttonStyle : null)
                .attr('class', rButtonClass)
                .attr('type', 'button')
                .attr('id', `${itemId}_${index}_0`)
                .optionalAttr('data-action', options.action)
                .optionalAttr('title', options.appearance == 'ICON' ? rLabel : null)
                .optionalAttr('disabled', renderDisabled)
                .markup('>');
            if (spanIconClass)
            {
                out.markup('<span')
                    .attr('class', spanIconClass)
                    .markup('></span>');
            }
            if (options.appearance.includes('TEXT'))
            {
                out.markup('<span')
                    .attr('class', 't-Button-label')
                    // hide label as long as not substituted
                    .optionalAttr('style', substPattern.test(rLabel) ? 'display:none' : null)
                    .markup('>')
                    .content(rLabel)
                    .markup('</span>');
            }
            out.markup('</button></div>');
            index += 1;    
            return out.toString();
        }        

        // function to get the interactiveGridView
        let _gridView = null;
        const getGridView = () => {
            if (!_gridView)
            {
                _gridView = item$.closest('.' + C_IG).interactiveGrid('getViews').grid;
            }
            return _gridView;
        }

        // function to set button disabled state for the active row (if any)
        const setButtonDisabledState = (disabled) => {
            let gridView = getGridView();
            let model = gridView.model;
            let activeRecordId = gridView.getActiveRecordId();
            if (activeRecordId)
            {
                let recMetadata = model.getRecordMetadata(activeRecordId);
                modelUtil.setFieldDisabled(model, activeRecordId, recMetadata, buttonColumnName, disabled);
                if (gridView.singleRowMode)
                {
                    let singleRow$ = ig$.find('.' + C_IG_RECORD_VIEW);
                    singleRow$.find('div.lib4x-column-button button[id^="' + itemId + '_"]').prop('disabled', disabled || !!recMetadata?.inserted); 
                }
                else
                {
                    let cell$ = gridView.view$.grid('getActiveCellFromColumnItem', apex.item(itemId).node);
                    if (cell$)
                    {
                        cell$.find('div.lib4x-column-button button').prop('disabled', disabled);
                    }
                }
            }
        }

        // implement the item interface specifics
        apex.item.create(itemId, {
            item_type: 'IG_BUTTON_COLUMN',   
            getValue(){
                return this.node.value;
            },      
            // setValue is not applicable - value is always read-only               
            disable(){
                setButtonDisabledState(true);
            },
            enable(){
                setButtonDisabledState(false);                            
            },
            isDisabled(){
                let buttonIsDisabled = false;
                let gridView = getGridView();
                let activeRecordId = gridView.getActiveRecordId();
                if (activeRecordId)
                {
                    let recMetadata = gridView.model.getRecordMetadata(activeRecordId);
                    buttonIsDisabled = modelUtil.getFieldMetaPropertyValue(recMetadata, buttonColumnName, 'disabled');
                }                 
                return buttonIsDisabled;
            },      
            // displayValueFor function will be called by APEX to get the cell content
            // so that will be HTML here
            displayValueFor(value, state) {
                return renderButton(value, state?.disabled);
            }
        });

        // apex.item.create() will add the item to apex.items
        // this one though is not needed there, so remove it
        delete apex.items[itemId];

        // forward any button click to the hidden column item as that one
        // might have any DA attached
        ig$.on('click', 'div.lib4x-column-button button[id^="' + itemId + '_"]', function(jQueryEvent){
            let gridView = getGridView();
            let data = {};
            data.model = gridView.model;      
            data.contextRecord = gridView.getContextRecord(jQueryEvent.currentTarget)[0];
            data.recordId = gridView.model.getRecordId(data.contextRecord);
            data.interactiveGridView = gridView;
            data.contextData = modelUtil.recordArrayToObject(data.model, data.contextRecord);
            apex.event.trigger(item$, 'click', data);
        });

        // in case the button is conditional enabled, listen to model events as to
        // set the field metadata disabled attribute
        if (enableCondition && (enableCondition.column || enableCondition.editAllowed))
        {
            ig$.on("interactivegridviewmodelcreate", function(jQueryEvent, data){ 
                let model = data.model;
                let evaluateRecords = function( changeType, change ){
                    let itr = change?.records ? change.records : (change?.record ? [change.record] : model);
                    itr.forEach(function (record){
                        let recordId = model.getRecordId(record);
                        let isDisabled = false;
                        if (enableCondition.column)
                        {
                            let condColumnValue = modelUtil.getNativeValue(model, record, enableCondition.column)
                            isDisabled = !pluginUtil.evaluateCondition(enableCondition, condColumnValue);
                        }
                        isDisabled = isDisabled ||  (enableCondition.editAllowed && !model.allowEdit(record));
                        let recMetadata = model.getRecordMetadata(recordId);
                        modelUtil.setFieldDisabled(model, recordId, recMetadata, buttonColumnName, isDisabled);
                        // setting the disabled flag in the record field metadata won't impact the button state in case
                        // the change type is set on active record or in case of delete
                        // so in those cases we will need to do it ourselves
                        if (changeType == 'set' || changeType == 'delete')
                        {
                            // gridView
                            let row$ = ig$.find("[data-id='" + recordId + "']");
                            row$.find('div.lib4x-column-button button[id^="' + itemId + '_"]').prop('disabled', isDisabled);
                            // singleRowView 
                            // SRV is not properly setting the is-readonly class on the container during insert mode
                            // upon field deactivate, it executes a setValue which will error
                            // to prevent, we keep it disabled
                            let singleRow$ = ig$.find('.' + C_IG_RECORD_VIEW);
                            singleRow$.find('div.lib4x-column-button button[id^="' + itemId + '_"]').prop('disabled', (isDisabled || !!recMetadata?.inserted)); 
                        }
                    });
                };
                let processOnChange = function(changeType, change){
                    let checkChangeTypes = ['addData', 'insert', 'copy', 'delete', 'refreshRecords', 'revert'];
                    if (checkChangeTypes.includes(changeType) || (changeType === 'set' && change.field === enableCondition.column))
                    {
                        evaluateRecords(changeType, change);
                    }
                }
                evaluateRecords('addData');  // initial set of records (in case no lazy loading)
                model.subscribe({
                    onChange: processOnChange
                });
            });
        }

        // function to apply label/class substitutions to lib4x column buttons as found in the IG
        // it will filter for not yet substituted labels/classes
        // also the button title (tooltip) might be the result from substitution
        const applySubstitutions = () => {
            function applyButtonAttrSubstitution(gridView, attrName)
            {
                let buttonSet$ = ig$.find('div.lib4x-column-button button[id^="' + itemId + '_"]').filter(function() {
                    return substPattern.test($(this).attr(attrName));
                });            
                buttonSet$.each(function(index, element){
                    let template = $(element).attr(attrName);
                    let record = gridView.getContextRecord(element)[0];
                    let attrValue = apex.util.applyTemplate(template, {model: model, record: record});
                    $(element).attr(attrName, attrValue);
                });
            }

            let gridView = getGridView();
            let model = gridView.model;
            if (labelSubst)
            {
                // filter non-substituted labels
                let labelSet$ = ig$.find('div.lib4x-column-button button[id^="' + itemId + '_"] span.t-Button-label').filter(function() {
                    return substPattern.test($(this).text());
                });
                labelSet$.each(function(index, element){
                    let template = $(element).text();
                    let record = gridView.getContextRecord(element)[0];     // also works for SRV
                    let label = apex.util.applyTemplate(template, {model: model, record: record}) || columnLabel;                   
                    $(element).text(label);
                    $(element).removeAttr('style');
                });
                applyButtonAttrSubstitution(gridView, 'title');                
            }
            if (classSubst)
            {
                applyButtonAttrSubstitution(gridView, 'class'); 
            } 
        };

        // apply any substitutions on appropriate events (label/css classes, button title)
        if (labelSubst || classSubst)
        {
            ig$.on("gridpagechange", function(jQueryEvent, data){ 
                applySubstitutions();
            });
            ig$.on("interactivegridviewmodelcreate", function(jQueryEvent, data){ 
                let model = data.model;
                model.subscribe({
                    onChange: function(changeType, change){
                        let checkChangeTypes = ['refreshRecords', 'revert', 'insert', 'copy'];
                        if (checkChangeTypes.includes(changeType))
                        {        
                            // use timeout as APEX is still yet to call the 'displayValueFor' method
                            setTimeout(applySubstitutions, 10);
                        }                
                    }
                });                
            });
        }

        // don't have any single-row-view button in the SRV itself
        if (options.action == 'single-row-view')
        {
            ig$.on("interactivegridcreate", function(jQueryEvent, data){ 
                apex.item(itemId).hide();
            });
        }
    }

    return{
        init: init
    }
    
})(apex.jQuery, apex.util);
