prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.0'
,p_default_workspace_id=>17062793957969100
,p_default_application_id=>138
,p_default_id_offset=>17513279999319301
,p_default_owner=>'CMF'
);
end;
/
 
prompt APPLICATION 138 - PKX
--
-- Application Export:
--   Application:     138
--   Name:            PKX
--   Date and Time:   18:51 Sunday May 11, 2025
--   Exported By:     KAREL
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 14340999435589023
--   Manifest End
--   Version:         24.2.0
--   Instance ID:     800104173856312
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/lib4x_axt_ig_buttoncolumn
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(14340999435589023)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'LIB4X.AXT.IG.BUTTONCOLUMN'
,p_display_name=>'LIB4X - IG Button Column'
,p_supported_component_types=>'APEX_APPL_PAGE_IG_COLUMNS'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'--------------------------------------------------------------------------------',
'-- t_item_attr type definition',
'--------------------------------------------------------------------------------',
'type t_item_attr is record',
'( ',
'    c_name                      varchar2(30),',
'    c_session_state_name        varchar2(30),    ',
'    c_appearance                varchar2(15),',
'    c_icon                      varchar2(100),',
'    c_label                     varchar2(50),',
'    c_type                      varchar(15),',
'    c_width                     varchar(15),',
'    c_width_px                  varchar(5),',
'    c_css_classes               varchar2(150),    ',
'    c_action                    varchar2(100),',
'    c_enable_cond_column        varchar2(50),',
'    c_enable_cond_type          varchar2(20),',
'    c_enable_cond_value         varchar2(50),',
'    c_enable_cond_edit_allowed  varchar2(1)',
'); ',
'',
'--------------------------------------------------------------------------------',
'-- init_item_attr Procedure',
'--------------------------------------------------------------------------------',
'procedure init_item_attr(',
'    p_item    in  apex_plugin.t_item,',
'    item_attr out t_item_attr',
')',
'is',
'begin',
'    item_attr.c_name                        := apex_plugin.get_input_name_for_item;',
'    item_attr.c_session_state_name          := p_item.session_state_name;',
'    item_attr.c_appearance                  := p_item.attributes.get_varchar2(''attr_appearance'');    ',
'    item_attr.c_icon                        := p_item.attributes.get_varchar2(''attr_icon'');',
'    item_attr.c_label                       := p_item.attributes.get_varchar2(''attr_label'');    ',
'    item_attr.c_type                        := p_item.attributes.get_varchar2(''attr_type'');',
'    item_attr.c_width                       := p_item.attributes.get_varchar2(''attr_width'');',
'    item_attr.c_width_px                    := p_item.attributes.get_varchar2(''attr_width_px'');',
'    item_attr.c_css_classes                 := p_item.attributes.get_varchar2(''attr_css_classes'');',
'    item_attr.c_action                      := p_item.attributes.get_varchar2(''attr_action'');    ',
'    item_attr.c_enable_cond_column          := p_item.attributes.get_varchar2(''attr_enable_cond_column'');',
'    item_attr.c_enable_cond_type            := p_item.attributes.get_varchar2(''attr_enable_cond_type'');',
'    item_attr.c_enable_cond_value           := p_item.attributes.get_varchar2(''attr_enable_cond_value'');',
'    item_attr.c_enable_cond_edit_allowed    := p_item.attributes.get_varchar2(''attr_enable_cond_edit_allowed'');',
'end init_item_attr;',
'',
'--------------------------------------------------------------------------------',
'-- Render Procedure',
'-- Adds on-load js as to init the button column client-side',
'--------------------------------------------------------------------------------',
'procedure render_ig_button (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result',
')',
'is',
'    item_attr           t_item_attr;',
'    ',
'    function get_icon_class(p_icon_name in varchar2) return varchar2 ',
'    is',
'    begin',
'        if p_icon_name like ''fa-%'' then',
'            return ''t-Icon fa '' || p_icon_name;',
'        elsif p_icon_name like ''icon-%'' then',
'            return ''a-Icon '' || p_icon_name;',
'        else',
'            return null;',
'        end if;',
'    end;    ',
'begin',
'    apex_plugin_util.debug_page_item(p_plugin => p_plugin, p_page_item => p_item);',
'    init_item_attr(p_item, item_attr);',
'    -- p_param.is_readonly will be true as attribute ''session state changable'' is not checked',
'    -- p_param.is_readonly being true, APEX will create a hidden input element with id as p_item.name  ',
'',
'    -- When specifying the library declaratively, it fails to load the minified version. So using the API:',
'    apex_javascript.add_library(',
'          p_name      => ''ig-buttoncolumn'',',
'          p_check_to_add_minified => true,',
'          --p_directory => ''#WORKSPACE_FILES#javascript/'',            ',
'          p_directory => p_plugin.file_prefix || ''js/'',',
'          p_version   => NULL',
'    );                ',
'',
'    -- page on load: init buttonColumn',
'    apex_javascript.add_onload_code(',
'        p_code => apex_string.format(',
'            ''lib4x.axt.ig.buttonColumn.init("%s", "%s", "%s", {appearance: "%s", iconClass: "%s", label: "%s", type: "%s", width: "%s", widthPixels: "%s", cssClasses: "%s", action: "%s"}, {column: "%s", type: "%s", value: "%s", editAllowed: %s});''',
'            , p_item.name ',
'            , p_item.session_state_name   ',
'            , p_item.label          ',
'            , item_attr.c_appearance',
'            , get_icon_class(item_attr.c_icon)',
'            , item_attr.c_label      ',
'            , item_attr.c_type   ',
'            , item_attr.c_width ',
'            , item_attr.c_width_px ',
'            , item_attr.c_css_classes   ',
'            , item_attr.c_action ',
'            , item_attr.c_enable_cond_column',
'            , item_attr.c_enable_cond_type            ',
'            , item_attr.c_enable_cond_value',
'            , case item_attr.c_enable_cond_edit_allowed when ''Y'' then ''true'' else ''false'' end',
'        )',
'    );',
'',
'end render_ig_button;',
'',
'--------------------------------------------------------------------------------',
'-- Meta Data Procedure',
'--------------------------------------------------------------------------------',
'procedure metadata_ig_button (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_meta_data_param,',
'    p_result in out nocopy apex_plugin.t_item_meta_data_result )',
'is',
'    item_attr   t_item_attr;     ',
'begin',
'    init_item_attr(p_item, item_attr);',
'    p_result.return_display_value := false;  -- return ''return'' value only for regular item display                                  ',
'    p_result.escape_output := false;',
'end metadata_ig_button;',
'',
'',
'',
'',
''))
,p_api_version=>3
,p_render_function=>'render_ig_button'
,p_meta_data_function=>'metadata_ig_button'
,p_standard_attributes=>'VISIBLE:SOURCE'
,p_substitute_attributes=>true
,p_version_scn=>355848215
,p_subscribe_plugin_settings=>true
,p_help_text=>'Displays a button on each row of an Interactive Grid. In case you make use of an Enable Condition, the column Source Type should be ''None''. Any attached Dynamic Action (on click) will have the row data in the this.data object.'
,p_version_identifier=>'1.0.0'
,p_about_url=>'https://github.com/kekema/apex-ig-button-column'
,p_files_version=>528
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(14534401074784920)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_title=>'Enable Condition'
,p_display_sequence=>10
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14441167124663270)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>20
,p_static_id=>'attr_icon'
,p_prompt=>'Icon'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_help_text=>'Specify the class for an icon to be added to the button.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14447524407054664)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>65
,p_static_id=>'attr_action'
,p_prompt=>'Action'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_examples=>'single-row-view'
,p_help_text=>'Can be used to specify any action from the action framework to be triggered upon button click. This is one way to have a logic attached to a button click, the other way is to attached a Dynamic Action (it will have the row data in the this.data objec'
||'t).'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14451304136136787)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'attr_label'
,p_prompt=>'Label'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_help_text=>'Specify the button label. Supports column substitution. You can leave the label empty to fallback on the button column value, however that can only be done if the button is always enabled. Reason: in case the button is disabled at moment of saving th'
||'e row, the column value is not submitted. And if the column was having an initial value, that would result in a session state violation error message as the column is a read-only column.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14453606448162873)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>60
,p_static_id=>'attr_css_classes'
,p_prompt=>'CSS Classes'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_help_text=>'Enter classes to add to this component. You may add multiple classes by separating them with spaces. Supports column substitution.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14457118877190315)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>10
,p_static_id=>'attr_appearance'
,p_prompt=>'Appearance'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_show_in_wizard=>false
,p_default_value=>'ICON'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select an option to define the appearance of this button.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14458253961191043)
,p_plugin_attribute_id=>wwv_flow_imp.id(14457118877190315)
,p_display_sequence=>10
,p_display_value=>'Icon'
,p_return_value=>'ICON'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14458618581192378)
,p_plugin_attribute_id=>wwv_flow_imp.id(14457118877190315)
,p_display_sequence=>20
,p_display_value=>'Text'
,p_return_value=>'TEXT'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14459074663193742)
,p_plugin_attribute_id=>wwv_flow_imp.id(14457118877190315)
,p_display_sequence=>30
,p_display_value=>'Text with Icon'
,p_return_value=>'TEXT_WITH_ICON'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14473130443664285)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>40
,p_static_id=>'attr_type'
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_show_in_wizard=>false
,p_default_value=>'NORMAL'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Impacts the stateful color of the button.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14474248728665232)
,p_plugin_attribute_id=>wwv_flow_imp.id(14473130443664285)
,p_display_sequence=>10
,p_display_value=>'Normal'
,p_return_value=>'NORMAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14474658130666531)
,p_plugin_attribute_id=>wwv_flow_imp.id(14473130443664285)
,p_display_sequence=>20
,p_display_value=>'Primary'
,p_return_value=>'PRIMARY'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14475042938667393)
,p_plugin_attribute_id=>wwv_flow_imp.id(14473130443664285)
,p_display_sequence=>30
,p_display_value=>'Warning'
,p_return_value=>'WARNING'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14475406426668248)
,p_plugin_attribute_id=>wwv_flow_imp.id(14473130443664285)
,p_display_sequence=>40
,p_display_value=>'Danger'
,p_return_value=>'DANGER'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14475842365670748)
,p_plugin_attribute_id=>wwv_flow_imp.id(14473130443664285)
,p_display_sequence=>50
,p_display_value=>'Success'
,p_return_value=>'SUCCESS'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14538341108803576)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>90
,p_static_id=>'attr_enable_cond_value'
,p_prompt=>'Value'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'EQUAL,NOT_EQUAL,GREATER,GREATER_EQUAL,LESS,LESS_EQUAL'
,p_attribute_group_id=>wwv_flow_imp.id(14534401074784920)
,p_help_text=>'Specify the value for the condition.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14544781240148365)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>70
,p_static_id=>'attr_enable_cond_column'
,p_prompt=>'Column'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(14534401074784920)
,p_help_text=>'Specify a column name in case the button enablement depends on the value of another column. When making use of the Enable Condition, make sure the column Source Type is ''None''.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14549986398042478)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>80
,p_static_id=>'attr_enable_cond_type'
,p_prompt=>'Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_show_in_wizard=>false
,p_default_value=>'EQUAL'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(14544781240148365)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_lov_type=>'STATIC'
,p_attribute_group_id=>wwv_flow_imp.id(14534401074784920)
,p_help_text=>'Specify the type of condition.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14550941892044545)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>10
,p_display_value=>'Column = Value'
,p_return_value=>'EQUAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14551367054047009)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>20
,p_display_value=>'Column != Value'
,p_return_value=>'NOT_EQUAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14551794789048889)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>30
,p_display_value=>'Column > Value'
,p_return_value=>'GREATER'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14552171959054723)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>40
,p_display_value=>'Column >= Value'
,p_return_value=>'GREATER_EQUAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14552573353056429)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>50
,p_display_value=>'Column < Value'
,p_return_value=>'LESS'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14552953194057429)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>60
,p_display_value=>'Column <= Value'
,p_return_value=>'LESS_EQUAL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14553333478058809)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>70
,p_display_value=>'Column is null'
,p_return_value=>'NULL'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14553725339059787)
,p_plugin_attribute_id=>wwv_flow_imp.id(14549986398042478)
,p_display_sequence=>80
,p_display_value=>'Column is not null'
,p_return_value=>'NOT_NULL'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14636340231909560)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>100
,p_static_id=>'attr_enable_cond_edit_allowed'
,p_prompt=>'Edit Allowed'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_show_in_wizard=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(14534401074784920)
,p_help_text=>'Check if the button only to be enabled in case row editing is allowed. When making use of the Enable Condition, make sure the column Source Type is ''None''.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14642581590323398)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>50
,p_static_id=>'attr_width'
,p_prompt=>'Width'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_show_in_wizard=>false
,p_default_value=>'DEFAULT'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'''Default'' will result in a width as per the content of the button (icon/label). ''Stretch'' will utilize the full column width (for Grid View only; in case of Single Row View, there will be no effect). Use ''Pixels'' for a custom setting.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14643292249324276)
,p_plugin_attribute_id=>wwv_flow_imp.id(14642581590323398)
,p_display_sequence=>10
,p_display_value=>'Default'
,p_return_value=>'DEFAULT'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14643645989330434)
,p_plugin_attribute_id=>wwv_flow_imp.id(14642581590323398)
,p_display_sequence=>20
,p_display_value=>'Stretch'
,p_return_value=>'STRETCH'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(14644048514332076)
,p_plugin_attribute_id=>wwv_flow_imp.id(14642581590323398)
,p_display_sequence=>30
,p_display_value=>'Pixels'
,p_return_value=>'PIXELS'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(14644856636337987)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>55
,p_static_id=>'attr_width_px'
,p_prompt=>'Width (px)'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_show_in_wizard=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(14642581590323398)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'PIXELS'
,p_help_text=>'Custom width in pixels.'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0A202A2040617574686F72204B6172656C20456B656D610A202A20406C6963656E7365204D4954206C6963656E73650A202A20436F70797269676874202863292032303235204B6172656C20456B656D610A202A0A202A205065726D697373696F';
wwv_flow_imp.g_varchar2_table(2) := '6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E7920706572736F6E206F627461696E696E67206120636F70790A202A206F66207468697320736F66747761726520616E64206173736F63696174';
wwv_flow_imp.g_varchar2_table(3) := '656420646F63756D656E746174696F6E2066696C657320287468652027536F66747761726527292C20746F206465616C0A202A20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E672077';
wwv_flow_imp.g_varchar2_table(4) := '6974686F7574206C696D69746174696F6E20746865207269676874730A202A20746F207573652C20636F70792C206D6F646966792C206D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F72';
wwv_flow_imp.g_varchar2_table(5) := '2073656C6C0A202A20636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F2077686F6D2074686520536F6674776172652069730A202A206675726E697368656420746F20646F20736F';
wwv_flow_imp.g_varchar2_table(6) := '2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A202A0A202A205468652061626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F746963652073';
wwv_flow_imp.g_varchar2_table(7) := '68616C6C20626520696E636C7564656420696E20616C6C0A202A20636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674776172652E0A202A0A202A2054484520534F4654574152452049532050524F';
wwv_flow_imp.g_varchar2_table(8) := '564944454420274153204953272C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A202A20494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F20544845';
wwv_flow_imp.g_varchar2_table(9) := '2057415252414E54494553204F46204D45524348414E544142494C4954592C0A202A204649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54';
wwv_flow_imp.g_varchar2_table(10) := '205348414C4C205448450A202A20415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845520A202A204C494142494C4954592C2057';
wwv_flow_imp.g_varchar2_table(11) := '48455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A202A204F5554204F46204F5220494E20434F4E4E454354494F4E2057495448205448';
wwv_flow_imp.g_varchar2_table(12) := '4520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A202A20534F4654574152452E0A202A2F0A0A77696E646F772E6C69623478203D2077696E646F772E6C69623478207C7C207B7D3B0A';
wwv_flow_imp.g_varchar2_table(13) := '77696E646F772E6C696234782E617874203D2077696E646F772E6C696234782E617874207C7C207B7D3B0A77696E646F772E6C696234782E6178742E6967203D2077696E646F772E6C696234782E6178742E6967207C7C207B7D3B0A0A2F2A2042757474';
wwv_flow_imp.g_varchar2_table(14) := '6F6E436F6C756D6E0A202A20506C7567696E20656E61626C696E67206120627574746F6E20636F6C756D6E20696E2049472E20444127732063616E206265206174746163686564206F7220616E20616374696F6E2063616E0A202A206265207370656369';
wwv_flow_imp.g_varchar2_table(15) := '66696564202866726F6D20616374696F6E206672616D65776F726B2920666F7220616E7920627574746F6E20636C69636B20666F6C6C6F772075702E200A202A20546865726520697320737570706F727420666F7220636F6E646974696F6E616C20656E';
wwv_flow_imp.g_varchar2_table(16) := '61626C696E6720616E6420666F7220627574746F6E206C6162656C2F636C61737320737562737469747574696F6E2C0A202A206261736564206F6E2074686520726F7720646174612E0A202A200A202A205768656E206D616B696E6720757365206F6620';
wwv_flow_imp.g_varchar2_table(17) := '636F6E646974696F6E616C20656E61626C696E67206F6620627574746F6E732C20697420697320696D706F7274616E7420746F2068617665207468650A202A20636F6C756D6E20536F75726365205479706520617320274E6F6E65272E20536F20746865';
wwv_flow_imp.g_varchar2_table(18) := '20636F6C756D6E20776F6E2774206861766520616E792076616C7565732E20526561736F6E732069732C207768656E0A202A206120627574746F6E2069732064697361626C65642C20616E7920627574746F6E20636F6C756D6E2076616C756520776F6E';
wwv_flow_imp.g_varchar2_table(19) := '2774206265207375626D69747465642075706F6E206120726F7720736176652C0A202A20726573756C74696E6720696E20612053657373696F6E2053746174652056696F6C6174696F6E206572726F7220696E206361736520696E697469616C6C792074';
wwv_flow_imp.g_varchar2_table(20) := '686572652077617320612076616C75652E0A202A2F0A6C696234782E6178742E69672E627574746F6E436F6C756D6E203D202866756E6374696F6E28242C207574696C29207B0A0A20202020636F6E737420435F4947203D2027612D4947273B0A202020';
wwv_flow_imp.g_varchar2_table(21) := '20636F6E737420435F434F4C554D4E5F4954454D535F434F4E5441494E4552203D2027612D47562D636F6C756D6E4974656D436F6E7461696E6572273B0A20202020636F6E737420435F49475F5245434F52445F56494557203D2027612D49472D726563';
wwv_flow_imp.g_varchar2_table(22) := '6F726456696577273B0A0A202020206C657420706C7567696E5574696C203D207B0A20202020202020202F2F206576616C75617465732074686520676976656E20636F6C756D6E56616C756520616761696E73742074686520636F6E646974696F6E2074';
wwv_flow_imp.g_varchar2_table(23) := '79706520616E642076616C75650A20202020202020206576616C75617465436F6E646974696F6E3A2066756E6374696F6E28636F6E646974696F6E2C20636F6C756D6E56616C7565290A20202020202020207B0A202020202020202020202020636F6E73';
wwv_flow_imp.g_varchar2_table(24) := '74207B20747970652C2076616C7565207D203D20636F6E646974696F6E3B0A0A2020202020202020202020202F2F20617474656D7074206E756D6572696320636F6E76657273696F6E20696620626F74682061726520737472696E6779206E756D626572';
wwv_flow_imp.g_varchar2_table(25) := '730A202020202020202020202020636F6E7374206C6566744E756D203D204E756D62657228636F6C756D6E56616C7565293B0A202020202020202020202020636F6E73742072696768744E756D203D204E756D6265722876616C7565293B0A2020202020';
wwv_flow_imp.g_varchar2_table(26) := '20202020202020636F6E737420626F74684172654E756D65726963203D20636F6C756D6E56616C75652026262076616C7565202626202169734E614E286C6566744E756D29202626202169734E614E2872696768744E756D293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(27) := '202020636F6E7374206C656674203D20626F74684172654E756D65726963203F206C6566744E756D203A20636F6C756D6E56616C75653B0A202020202020202020202020636F6E7374207269676874203D20626F74684172654E756D65726963203F2072';
wwv_flow_imp.g_varchar2_table(28) := '696768744E756D203A2076616C75653B0A202020202020202020200A20202020202020202020202073776974636820287479706529207B0A2020202020202020202020202020636173652027455155414C273A0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(29) := '72657475726E206C656674203D3D3D2072696768743B0A20202020202020202020202020206361736520274E4F545F455155414C273A0A2020202020202020202020202020202072657475726E206C65667420213D3D2072696768743B0A202020202020';
wwv_flow_imp.g_varchar2_table(30) := '20202020202020206361736520274C455353273A0A2020202020202020202020202020202072657475726E206C656674203C2072696768743B0A20202020202020202020202020206361736520274C4553535F455155414C273A0A202020202020202020';
wwv_flow_imp.g_varchar2_table(31) := '2020202020202072657475726E206C656674203C3D2072696768743B0A202020202020202020202020202063617365202747524541544552273A0A2020202020202020202020202020202072657475726E206C656674203E2072696768743B0A20202020';
wwv_flow_imp.g_varchar2_table(32) := '20202020202020202020636173652027475245415445525F455155414C273A0A2020202020202020202020202020202072657475726E206C656674203E3D2072696768743B0A20202020202020202020202020206361736520274E554C4C273A0A202020';
wwv_flow_imp.g_varchar2_table(33) := '2020202020202020202020202072657475726E206C656674203D3D3D206E756C6C207C7C206C656674203D3D3D20756E646566696E6564207C7C206C656674203D3D3D2027273B0A20202020202020202020202020206361736520274E4F545F4E554C4C';
wwv_flow_imp.g_varchar2_table(34) := '273A0A2020202020202020202020202020202072657475726E206C65667420213D3D206E756C6C202626206C65667420213D3D20756E646566696E6564202626206C65667420213D3D2027273B0A202020202020202020202020202064656661756C743A';
wwv_flow_imp.g_varchar2_table(35) := '0A202020202020202020202020202020207468726F77206E6577204572726F722860556E6B6E6F776E20636F6E646974696F6E20747970653A20247B747970657D60293B0A2020202020202020202020207D0A20202020202020207D0A202020207D0A0A';
wwv_flow_imp.g_varchar2_table(36) := '202020202F2F206D6F64656C207574696C6974792066756E6374696F6E730A202020206C6574206D6F64656C5574696C203D207B0A20202020202020206765744669656C644D657461646174613A2066756E6374696F6E287265634D657461646174612C';
wwv_flow_imp.g_varchar2_table(37) := '206669656C644E616D652C2063726561746549664E6F74457869737473290A20202020202020207B0A2020202020202020202020206C657420726573756C74203D206E756C6C3B0A202020202020202020202020696620287265634D6574616461746129';
wwv_flow_imp.g_varchar2_table(38) := '0A2020202020202020202020207B0A2020202020202020202020202020202069662028217265634D657461646174612E6669656C6473290A202020202020202020202020202020207B0A2020202020202020202020202020202020202020696620286372';
wwv_flow_imp.g_varchar2_table(39) := '6561746549664E6F74457869737473290A20202020202020202020202020202020202020207B0A2020202020202020202020202020202020202020202020207265634D657461646174612E6669656C6473203D207B7D3B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(40) := '20202020202020207D0A202020202020202020202020202020207D0A202020202020202020202020202020206C6574206669656C64734D65746164617461203D207265634D657461646174612E6669656C64733B0A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(41) := '20696620286669656C64734D65746164617461290A202020202020202020202020202020207B0A202020202020202020202020202020202020202069662028216669656C64734D657461646174615B6669656C644E616D655D290A202020202020202020';
wwv_flow_imp.g_varchar2_table(42) := '20202020202020202020207B0A2020202020202020202020202020202020202020202020206966202863726561746549664E6F74457869737473290A2020202020202020202020202020202020202020202020207B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(43) := '20202020202020202020202020206669656C64734D657461646174615B6669656C644E616D655D203D207B7D3B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A202020202020';
wwv_flow_imp.g_varchar2_table(44) := '2020202020202020202020202020726573756C74203D206669656C64734D657461646174615B6669656C644E616D655D3B0A202020202020202020202020202020207D0A2020202020202020202020207D200A2020202020202020202020207265747572';
wwv_flow_imp.g_varchar2_table(45) := '6E20726573756C743B20202020202020202020200A20202020202020207D2C0A20202020202020206765744669656C644D65746150726F706572747956616C75653A2066756E6374696F6E287265634D657461646174612C206669656C644E616D652C20';
wwv_flow_imp.g_varchar2_table(46) := '6D65746150726F7065727479290A20202020202020207B0A2020202020202020202020206C657420726573756C74203D206E756C6C3B0A2020202020202020202020206C6574206669656C644D65746164617461203D20746869732E6765744669656C64';
wwv_flow_imp.g_varchar2_table(47) := '4D65746164617461287265634D657461646174612C206669656C644E616D652C2066616C7365293B0A202020202020202020202020696620286669656C644D65746164617461290A2020202020202020202020207B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(48) := '2020726573756C74203D206669656C644D657461646174615B6D65746150726F70657274795D3B0A2020202020202020202020207D0A20202020202020202020202072657475726E20726573756C743B0A20202020202020207D2C0A2020202020202020';
wwv_flow_imp.g_varchar2_table(49) := '7365744669656C644D65746150726F706572747956616C75653A2066756E6374696F6E286D6F64656C2C207265636F726449642C207265634D657461646174612C206669656C644E616D652C206D65746150726F70657274792C2076616C7565290A2020';
wwv_flow_imp.g_varchar2_table(50) := '2020202020207B0A202020202020202020202020696620287265634D65746164617461290A2020202020202020202020207B0A2020202020202020202020202020202069662028217265634D657461646174612E6669656C6473290A2020202020202020';
wwv_flow_imp.g_varchar2_table(51) := '20202020202020207B0A20202020202020202020202020202020202020207265634D657461646174612E6669656C6473203D207B7D3B0A202020202020202020202020202020207D0A202020202020202020202020202020206C6574206669656C64734D';
wwv_flow_imp.g_varchar2_table(52) := '65746164617461203D207265634D657461646174612E6669656C64733B0A2020202020202020202020202020202069662028216669656C64734D657461646174615B6669656C644E616D655D290A202020202020202020202020202020207B0A20202020';
wwv_flow_imp.g_varchar2_table(53) := '202020202020202020202020202020206669656C64734D657461646174615B6669656C644E616D655D203D207B7D3B0A202020202020202020202020202020207D0A202020202020202020202020202020206669656C64734D657461646174615B666965';
wwv_flow_imp.g_varchar2_table(54) := '6C644E616D655D5B6D65746150726F70657274795D203D2076616C75653B0A202020202020202020202020202020206D6F64656C2E6D657461646174614368616E676564287265636F726449642C206669656C644E616D652C206D65746150726F706572';
wwv_flow_imp.g_varchar2_table(55) := '7479293B200A2020202020202020202020207D200A20202020202020207D2C0A20202020202020206765745363616C617256616C75653A2066756E6374696F6E286D6F64656C2C207265636F72642C2070726F7065727479290A20202020202020207B0A';
wwv_flow_imp.g_varchar2_table(56) := '2020202020202020202020206C65742076616C7565203D206D6F64656C2E67657456616C7565287265636F72642C2070726F7065727479293B0A2020202020202020202020206966202876616C756520213D3D206E756C6C20262620747970656F662076';
wwv_flow_imp.g_varchar2_table(57) := '616C7565203D3D3D20226F626A656374222026262076616C75652E6861734F776E50726F706572747928202276222029290A2020202020202020202020207B0A2020202020202020202020202020202076616C7565203D2076616C75652E763B0A202020';
wwv_flow_imp.g_varchar2_table(58) := '202020202020202020202020206966202841727261792E697341727261792876616C756529290A202020202020202020202020202020207B0A20202020202020202020202020202020202020206C6574206D6F64656C4669656C6473203D206D6F64656C';
wwv_flow_imp.g_varchar2_table(59) := '2E6765744F7074696F6E28226669656C647322293B0A20202020202020202020202020202020202020206C6574206D6F64656C4669656C64203D206D6F64656C4669656C64735B70726F70657274795D3B0A202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(60) := '20206C657420736570617261746F72203D20273A273B0A2020202020202020202020202020202020202020696620286D6F64656C4669656C64202626206D6F64656C4669656C642E656C656D656E74496420262620617065782E6974656D286D6F64656C';
wwv_flow_imp.g_varchar2_table(61) := '4669656C642E656C656D656E744964292E676574536570617261746F72290A20202020202020202020202020202020202020207B0A202020202020202020202020202020202020202020202020736570617261746F72203D20617065782E6974656D286D';
wwv_flow_imp.g_varchar2_table(62) := '6F64656C4669656C642E656C656D656E744964292E676574536570617261746F7228293B0A2020202020202020202020202020202020202020202020206966202821736570617261746F72290A2020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(63) := '207B0A20202020202020202020202020202020202020202020202020202020736570617261746F72203D20223A223B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D0A20202020';
wwv_flow_imp.g_varchar2_table(64) := '2020202020202020202020202020202076616C7565203D2076616C75652E6A6F696E285B736570617261746F72203D20736570617261746F725D293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020';
wwv_flow_imp.g_varchar2_table(65) := '202020202072657475726E2076616C75653B0A20202020202020207D2C0A20202020202020206765744E617469766556616C75653A2066756E6374696F6E286D6F64656C2C207265636F72642C2070726F7065727479290A20202020202020207B0A2020';
wwv_flow_imp.g_varchar2_table(66) := '202020202020202020206C65742076616C7565203D20746869732E6765745363616C617256616C7565286D6F64656C2C207265636F72642C2070726F7065727479293B0A2020202020202020202020206C6574206E617469766556616C7565203D207661';
wwv_flow_imp.g_varchar2_table(67) := '6C75653B0A2020202020202020202020206C6574206D6F64656C4669656C6473203D206D6F64656C2E6765744F7074696F6E28226669656C647322293B0A2020202020202020202020206C6574206D6F64656C4669656C64203D206D6F64656C4669656C';
wwv_flow_imp.g_varchar2_table(68) := '64735B70726F70657274795D3B0A2020202020202020202020206C6574206461746154797065203D206D6F64656C4669656C642E64617461547970653B0A202020202020202020202020696620286461746154797065203D3D20274E554D42455227290A';
wwv_flow_imp.g_varchar2_table(69) := '2020202020202020202020207B0A202020202020202020202020202020206966202876616C7565290A202020202020202020202020202020207B0A20202020202020202020202020202020202020206E617469766556616C7565203D20617065782E6C6F';
wwv_flow_imp.g_varchar2_table(70) := '63616C652E746F4E756D6265722876616C75652C206D6F64656C4669656C642E666F726D61744D61736B293B0A202020202020202020202020202020207D0A20202020202020202020202020202020656C73650A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(71) := '7B0A20202020202020202020202020202020202020206E617469766556616C7565203D206E756C6C3B0A202020202020202020202020202020207D0A2020202020202020202020207D0A202020202020202020202020656C736520696620286461746154';
wwv_flow_imp.g_varchar2_table(72) := '797065203D3D20274441544527290A2020202020202020202020207B0A202020202020202020202020202020206E617469766556616C7565203D206E756C6C3B0A202020202020202020202020202020206966202876616C7565290A2020202020202020';
wwv_flow_imp.g_varchar2_table(73) := '20202020202020207B20202020202020200A20202020202020202020202020202020202020207472790A20202020202020202020202020202020202020207B0A2020202020202020202020202020202020202020202020206E617469766556616C756520';
wwv_flow_imp.g_varchar2_table(74) := '3D20617065782E646174652E70617273652876616C75652C206D6F64656C4669656C642E666F726D61744D61736B293B0A20202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020636174636828657272';
wwv_flow_imp.g_varchar2_table(75) := '6F7229200A20202020202020202020202020202020202020207B0A202020202020202020202020202020202020202020202020636F6E736F6C652E6C6F672827496E76616C696420646174653A2027202B2076616C7565293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(76) := '202020202020202020207D0A2020202020202020202020202020202020202020696620286E617469766556616C7565290A20202020202020202020202020202020202020207B0A2020202020202020202020202020202020202020202020202F2F206E61';
wwv_flow_imp.g_varchar2_table(77) := '7469766556616C7565203D206E617469766556616C75652E746F49534F537472696E6728293B20202F2F207468697320676976657320612055544320646174652E2045673A20323032342D30312D32365431323A30303A30305A0A202020202020202020';
wwv_flow_imp.g_varchar2_table(78) := '2020202020202020202020202020202F2F2044415445207479706520696E204F7261636C6520686173206E6F2074696D657A6F6E6520696E666F2C20736F2077652073656E642070617273656420646174652061732D69732C2073616D65206173204947';
wwv_flow_imp.g_varchar2_table(79) := '2069732073656E64696E672075706F6E20736176650A2020202020202020202020202020202020202020202020206E617469766556616C7565203D20617065782E646174652E746F49534F537472696E67286E617469766556616C7565293B2020202F2F';
wwv_flow_imp.g_varchar2_table(80) := '2049534F20737472696E6720776974686F75742074696D657A6F6E652E2045673A20323032342D30312D32365431333A30303A30300A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A202020202020';
wwv_flow_imp.g_varchar2_table(81) := '20202020202020202020656C73650A202020202020202020202020202020207B0A20202020202020202020202020202020202020206E617469766556616C7565203D206E756C6C3B0A202020202020202020202020202020207D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(82) := '2020207D0A20202020202020202020202072657475726E206E617469766556616C75653B0A20202020202020207D2C0A20202020202020207365744669656C6444697361626C65643A2066756E6374696F6E286D6F64656C2C207265636F726449642C20';
wwv_flow_imp.g_varchar2_table(83) := '7265634D657461646174612C206669656C644E616D652C2064697361626C6564290A20202020202020207B0A202020202020202020202020746869732E7365744669656C644D65746150726F706572747956616C7565286D6F64656C2C207265636F7264';
wwv_flow_imp.g_varchar2_table(84) := '49642C207265634D657461646174612C206669656C644E616D652C202764697361626C6564272C2064697361626C6564293B0A20202020202020207D2C0A202020202020202069735265636F72644669656C643A2066756E6374696F6E286D6F64656C46';
wwv_flow_imp.g_varchar2_table(85) := '69656C64290A20202020202020207B0A20202020202020202020202072657475726E20286D6F64656C4669656C642E6861734F776E50726F70657274792827696E6465782729202626206D6F64656C4669656C642E70726F706572747920213D20275F6D';
wwv_flow_imp.g_varchar2_table(86) := '65746127293B20202F2F206D6F64656C2E6765744F7074696F6E28276D6574614669656C6427290A20202020202020207D2C202020202020202020200A20202020202020207265636F72644172726179546F4F626A6563743A2066756E6374696F6E286D';
wwv_flow_imp.g_varchar2_table(87) := '6F64656C2C207265636F7264290A20202020202020207B0A2020202020202020202020206C6574207265636F72644F626A656374203D206E756C6C3B0A2020202020202020202020206C6574206D6F64656C4669656C6473203D206D6F64656C2E676574';
wwv_flow_imp.g_varchar2_table(88) := '4F7074696F6E28226669656C647322293B0A202020202020202020202020696620287265636F7264202626206D6F64656C4669656C6473290A2020202020202020202020207B0A202020202020202020202020202020207265636F72644F626A65637420';
wwv_flow_imp.g_varchar2_table(89) := '3D207B7D3B0A20202020202020202020202020202020666F722028636F6E7374205B6669656C644E616D652C206D6F64656C4669656C645D206F66204F626A6563742E656E7472696573286D6F64656C4669656C647329290A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(90) := '20202020207B20200A202020202020202020202020202020202020202069662028746869732E69735265636F72644669656C64286D6F64656C4669656C6429290A20202020202020202020202020202020202020207B0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(91) := '20202020202020202020207265636F72644F626A6563745B6669656C644E616D655D203D20746869732E6765744E617469766556616C7565286D6F64656C2C207265636F72642C206669656C644E616D65293B0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(92) := '202020207D0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020202020202072657475726E207265636F72644F626A6563743B0A20202020202020207D20202020200A202020207D3B0A0A202020202F2F';
wwv_flow_imp.g_varchar2_table(93) := '20496E697420746865206974656D202D2077696C6C2062652063616C6C6564206F6E2070616765206C6F61640A202020202F2F20496E2074686520696E697420686572652C20746865207370656369666963206974656D20696E74657266616365206973';
wwv_flow_imp.g_varchar2_table(94) := '20736574207570206279206170706C79696E6720617065782E6974656D2E6372656174652E0A202020202F2F20436C69656E742D736964652C207468652068746D6C20666F722074686520627574746F6E2069732067656E6572617465642E0A20202020';
wwv_flow_imp.g_varchar2_table(95) := '6C657420696E6974203D2066756E6374696F6E286974656D49642C20627574746F6E436F6C756D6E4E616D652C20636F6C756D6E4C6162656C2C206F7074696F6E732C20656E61626C65436F6E646974696F6E290A202020207B200A2020202020202020';
wwv_flow_imp.g_varchar2_table(96) := '636F6E73742073756273745061747465726E203D202F265B5E2E5D2A5C2E2F3B202020202F2F207061747465726E2026585858582E206173207573656420666F7220737562737469747574696F6E730A0A20202020202020206C657420696E646578203D';
wwv_flow_imp.g_varchar2_table(97) := '20303B20202F2F207573656420746F2067656E657261746520756E6971756520627574746F6E2069642773200A20202020202020206C6574206C6162656C5375627374203D2073756273745061747465726E2E74657374286F7074696F6E732E6C616265';
wwv_flow_imp.g_varchar2_table(98) := '6C293B0A20202020202020206C657420636C6173735375627374203D2073756273745061747465726E2E74657374286F7074696F6E732E637373436C6173736573293B0A0A20202020202020206C65742074797065436C617373203D207B7D3B0A202020';
wwv_flow_imp.g_varchar2_table(99) := '202020202074797065436C6173735B274E4F524D414C275D203D206E756C6C3B0A202020202020202074797065436C6173735B275052494D415259275D203D2027742D427574746F6E2D2D7072696D617279273B0A202020202020202074797065436C61';
wwv_flow_imp.g_varchar2_table(100) := '73735B275741524E494E47275D203D2027742D427574746F6E2D2D7761726E696E67273B0A202020202020202074797065436C6173735B2744414E474552275D203D2027742D427574746F6E2D2D64616E676572273B0A20202020202020207479706543';
wwv_flow_imp.g_varchar2_table(101) := '6C6173735B2753554343455353275D203D2027742D427574746F6E2D2D73756363657373273B0A0A20202020202020202F2F20636F6D706F736520627574746F6E2F7370616E20636C61737365730A20202020202020206C657420627574746F6E436C61';
wwv_flow_imp.g_varchar2_table(102) := '7373203D206E756C6C3B0A20202020202020206C6574207370616E49636F6E436C617373203D206E756C6C3B0A2020202020202020696620286F7074696F6E732E617070656172616E6365203D3D202749434F4E27290A20202020202020207B0A202020';
wwv_flow_imp.g_varchar2_table(103) := '202020202020202020627574746F6E436C617373203D2027742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C2020742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C273B0A202020202020202020202020737061';
wwv_flow_imp.g_varchar2_table(104) := '6E49636F6E436C617373203D2027742D49636F6E2027202B206F7074696F6E732E69636F6E436C6173733B0A20202020202020207D0A2020202020202020656C736520696620286F7074696F6E732E617070656172616E6365203D3D2027544558545F57';
wwv_flow_imp.g_varchar2_table(105) := '4954485F49434F4E27290A20202020202020207B0A202020202020202020202020627574746F6E436C617373203D2027742D427574746F6E20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C20742D427574746F6E2D2D6963';
wwv_flow_imp.g_varchar2_table(106) := '6F6E4C656674273B0A2020202020202020202020207370616E49636F6E436C617373203D2027742D49636F6E20742D49636F6E2D2D6C6566742027202B206F7074696F6E732E69636F6E436C6173733B0A20202020202020207D0A202020202020202065';
wwv_flow_imp.g_varchar2_table(107) := '6C7365202F2F202754455854270A20202020202020207B0A202020202020202020202020627574746F6E436C617373203D2027742D427574746F6E20742D427574746F6E2D2D736D616C6C273B0A20202020202020207D0A202020202020202062757474';
wwv_flow_imp.g_varchar2_table(108) := '6F6E436C617373203D20627574746F6E436C617373202B202874797065436C6173735B6F7074696F6E732E747970655D203F20272027202B2074797065436C6173735B6F7074696F6E732E747970655D203A202727293B0A202020202020202062757474';
wwv_flow_imp.g_varchar2_table(109) := '6F6E436C617373203D20627574746F6E436C617373202B20286F7074696F6E732E637373436C6173736573203F20272027202B206F7074696F6E732E637373436C6173736573203A202727293B0A0A20202020202020202F2F20636F6D706F7365206275';
wwv_flow_imp.g_varchar2_table(110) := '74746F6E5374796C650A20202020202020206C657420627574746F6E5374796C65203D206E756C6C3B0A2020202020202020696620286F7074696F6E732E7769647468203D3D20275354524554434827290A20202020202020207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(111) := '20202020627574746F6E5374796C65203D2027646973706C61793A20626C6F636B3B2077696474683A20313030253B273B0A20202020202020207D0A2020202020202020656C736520696620286F7074696F6E732E7769647468203D3D2027504958454C';
wwv_flow_imp.g_varchar2_table(112) := '5327290A20202020202020207B0A202020202020202020202020627574746F6E5374796C65203D202777696474683A2027202B206F7074696F6E732E7769647468506978656C73202B202770783B270A20202020202020207D0A0A20202020202020202F';
wwv_flow_imp.g_varchar2_table(113) := '2F20746865207365727665722D736964652067656E6572617465642068696464656E20696E70757420656C656D656E742077696C6C206E65766572206265207377617070656420696E746F207468652049472061730A20202020202020202F2F20697420';
wwv_flow_imp.g_varchar2_table(114) := '6973206120726561642D6F6E6C7920636F6C756D6E0A2020202020202020636F6E7374206974656D24203D2024286023247B6974656D49647D60293B0A2020202020202020636F6E737420696724203D206974656D242E636C6F7365737428272E27202B';
wwv_flow_imp.g_varchar2_table(115) := '20435F434F4C554D4E5F4954454D535F434F4E5441494E4552292E636C6F7365737428226469765B6964243D275F6967275D22293B0A0A20202020202020202F2F2066756E6374696F6E20746F2072656E6465722074686520627574746F6E0A20202020';
wwv_flow_imp.g_varchar2_table(116) := '202020202F2F207468652072656E646572696E672069732066726F6D20646973706C617956616C7565466F7220696E20746865206974656D20696E746572666163650A20202020202020202F2F20617320746F2072656E64657220666F72206561636820';
wwv_flow_imp.g_varchar2_table(117) := '616E6420657665727920726F770A2020202020202020636F6E73742072656E646572427574746F6E203D202876616C75652C2072656E64657244697361626C656429203D3E207B0A2020202020202020202020206C6574206772696456696577203D2067';
wwv_flow_imp.g_varchar2_table(118) := '6574477269645669657728293B0A2020202020202020202020206C65742073696E676C65526F774D6F6465203D20212167726964566965772E73696E676C65526F774D6F64653B0A2020202020202020202020206C6574207265636F72644964203D206E';
wwv_flow_imp.g_varchar2_table(119) := '756C6C3B0A2020202020202020202020206966202873696E676C65526F774D6F6465290A2020202020202020202020207B0A202020202020202020202020202020207265636F72644964203D2067726964566965772E73696E676C65526F775669657724';
wwv_flow_imp.g_varchar2_table(120) := '2E7265636F7264566965772827696E7374616E636527292E63757272656E745265636F726449643B20202020200A20202020202020202020202020202020696620287265636F72644964202626202172656E64657244697361626C6564290A2020202020';
wwv_flow_imp.g_varchar2_table(121) := '20202020202020202020207B0A20202020202020202020202020202020202020206C6574207265634D65746164617461203D2067726964566965772E6D6F64656C2E6765745265636F72644D65746164617461287265636F72644964293B0A2020202020';
wwv_flow_imp.g_varchar2_table(122) := '2020202020202020202020202020202F2F20535256206973206E6F742070726F7065726C792073657474696E67207468652069732D726561646F6E6C7920636C617373206F6E2074686520636F6E7461696E657220647572696E6720696E73657274206D';
wwv_flow_imp.g_varchar2_table(123) := '6F64650A20202020202020202020202020202020202020202F2F2075706F6E206669656C6420646561637469766174652C20697420657865637574657320612073657456616C75652077686963682077696C6C206572726F720A20202020202020202020';
wwv_flow_imp.g_varchar2_table(124) := '202020202020202020202F2F20746F2070726576656E742C207765206B6565702069742064697361626C65640A202020202020202020202020202020202020202072656E64657244697361626C6564203D20202821217265634D657461646174613F2E69';
wwv_flow_imp.g_varchar2_table(125) := '6E736572746564293B0A202020202020202020202020202020207D0A2020202020202020202020207D202020202020200A2020202020202020202020206C657420724C6162656C203D206F7074696F6E732E6C6162656C207C7C2076616C75653B0A2020';
wwv_flow_imp.g_varchar2_table(126) := '202020202020202020206C65742072427574746F6E436C617373203D20627574746F6E436C6173733B0A2020202020202020202020202F2F20666F722053696E676C65526F77566965772C2077652063616E20646F20737562737469747574696F6E7320';
wwv_flow_imp.g_varchar2_table(127) := '6F766572206865726520617320746865207265636F7264206973206B6E6F776E2020202020202020202020200A2020202020202020202020206966202873696E676C65526F774D6F6465202626207265636F7264496420262620286C6162656C53756273';
wwv_flow_imp.g_varchar2_table(128) := '74207C7C20636C617373537562737429290A2020202020202020202020207B0A202020202020202020202020202020206C65742074656D706C6174654F7074696F6E73203D207B6D6F64656C3A2067726964566965772E6D6F64656C2C207265636F7264';
wwv_flow_imp.g_varchar2_table(129) := '3A2067726964566965772E6D6F64656C2E6765745265636F7264287265636F72644964297D3B0A20202020202020202020202020202020696620286C6162656C5375627374290A202020202020202020202020202020207B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(130) := '202020202020202020724C6162656C203D20617065782E7574696C2E6170706C7954656D706C61746528724C6162656C2C2074656D706C6174654F7074696F6E73293B0A202020202020202020202020202020207D0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(131) := '202069662028636C6173735375627374290A202020202020202020202020202020207B0A202020202020202020202020202020202020202072427574746F6E436C617373203D20617065782E7574696C2E6170706C7954656D706C617465287242757474';
wwv_flow_imp.g_varchar2_table(132) := '6F6E436C6173732C2074656D706C6174654F7074696F6E73293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A2020202020202020202020206966202821724C6162656C290A2020202020202020202020207B0A2020';
wwv_flow_imp.g_varchar2_table(133) := '2020202020202020202020202020724C6162656C203D20636F6C756D6E4C6162656C3B0A2020202020202020202020207D0A2020202020202020202020202F2F206275696C642074686520627574746F6E2068746D6C0A20202020202020202020202063';
wwv_flow_imp.g_varchar2_table(134) := '6F6E7374206F7574203D207574696C2E68746D6C4275696C64657228293B20202020200A2020202020202020202020206F75742E6D61726B757028273C64697627290A202020202020202020202020202020202E617474722827636C617373272C20276C';
wwv_flow_imp.g_varchar2_table(135) := '696234782D636F6C756D6E2D627574746F6E27290A202020202020202020202020202020202E6D61726B757028273E3C627574746F6E27290A202020202020202020202020202020202E6F7074696F6E616C4174747228277374796C65272C202173696E';
wwv_flow_imp.g_varchar2_table(136) := '676C65526F774D6F6465203F20627574746F6E5374796C65203A206E756C6C290A202020202020202020202020202020202E617474722827636C617373272C2072427574746F6E436C617373290A202020202020202020202020202020202E6174747228';
wwv_flow_imp.g_varchar2_table(137) := '2774797065272C2027627574746F6E27290A202020202020202020202020202020202E6174747228276964272C2060247B6974656D49647D5F247B696E6465787D5F3060290A202020202020202020202020202020202E6F7074696F6E616C4174747228';
wwv_flow_imp.g_varchar2_table(138) := '27646174612D616374696F6E272C206F7074696F6E732E616374696F6E290A202020202020202020202020202020202E6F7074696F6E616C4174747228277469746C65272C206F7074696F6E732E617070656172616E6365203D3D202749434F4E27203F';
wwv_flow_imp.g_varchar2_table(139) := '20724C6162656C203A206E756C6C290A202020202020202020202020202020202E6F7074696F6E616C41747472282764697361626C6564272C2072656E64657244697361626C6564290A202020202020202020202020202020202E6D61726B757028273E';
wwv_flow_imp.g_varchar2_table(140) := '27293B0A202020202020202020202020696620287370616E49636F6E436C617373290A2020202020202020202020207B0A202020202020202020202020202020206F75742E6D61726B757028273C7370616E27290A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(141) := '20202020202E617474722827636C617373272C207370616E49636F6E436C617373290A20202020202020202020202020202020202020202E6D61726B757028273E3C2F7370616E3E27293B0A2020202020202020202020207D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(142) := '2020696620286F7074696F6E732E617070656172616E63652E696E636C756465732827544558542729290A2020202020202020202020207B0A202020202020202020202020202020206F75742E6D61726B757028273C7370616E27290A20202020202020';
wwv_flow_imp.g_varchar2_table(143) := '202020202020202020202020202E617474722827636C617373272C2027742D427574746F6E2D6C6162656C27290A20202020202020202020202020202020202020202F2F2068696465206C6162656C206173206C6F6E67206173206E6F74207375627374';
wwv_flow_imp.g_varchar2_table(144) := '6974757465640A20202020202020202020202020202020202020202E6F7074696F6E616C4174747228277374796C65272C2073756273745061747465726E2E7465737428724C6162656C29203F2027646973706C61793A6E6F6E6527203A206E756C6C29';
wwv_flow_imp.g_varchar2_table(145) := '0A20202020202020202020202020202020202020202E6D61726B757028273E27290A20202020202020202020202020202020202020202E636F6E74656E7428724C6162656C290A20202020202020202020202020202020202020202E6D61726B75702827';
wwv_flow_imp.g_varchar2_table(146) := '3C2F7370616E3E27293B0A2020202020202020202020207D0A2020202020202020202020206F75742E6D61726B757028273C2F627574746F6E3E3C2F6469763E27293B0A202020202020202020202020696E646578202B3D20313B202020200A20202020';
wwv_flow_imp.g_varchar2_table(147) := '202020202020202072657475726E206F75742E746F537472696E6728293B0A20202020202020207D20202020202020200A0A20202020202020202F2F2066756E6374696F6E20746F206765742074686520696E7465726163746976654772696456696577';
wwv_flow_imp.g_varchar2_table(148) := '0A20202020202020206C6574205F6772696456696577203D206E756C6C3B0A2020202020202020636F6E7374206765744772696456696577203D202829203D3E207B0A20202020202020202020202069662028215F6772696456696577290A2020202020';
wwv_flow_imp.g_varchar2_table(149) := '202020202020207B0A202020202020202020202020202020205F6772696456696577203D206974656D242E636C6F7365737428272E27202B20435F4947292E696E746572616374697665477269642827676574566965777327292E677269643B0A202020';
wwv_flow_imp.g_varchar2_table(150) := '2020202020202020207D0A20202020202020202020202072657475726E205F67726964566965773B0A20202020202020207D0A0A20202020202020202F2F2066756E6374696F6E20746F2073657420627574746F6E2064697361626C6564207374617465';
wwv_flow_imp.g_varchar2_table(151) := '20666F72207468652061637469766520726F772028696620616E79290A2020202020202020636F6E737420736574427574746F6E44697361626C65645374617465203D202864697361626C656429203D3E207B0A2020202020202020202020206C657420';
wwv_flow_imp.g_varchar2_table(152) := '6772696456696577203D20676574477269645669657728293B0A2020202020202020202020206C6574206D6F64656C203D2067726964566965772E6D6F64656C3B0A2020202020202020202020206C6574206163746976655265636F72644964203D2067';
wwv_flow_imp.g_varchar2_table(153) := '726964566965772E6765744163746976655265636F7264496428293B0A202020202020202020202020696620286163746976655265636F72644964290A2020202020202020202020207B0A202020202020202020202020202020206C6574207265634D65';
wwv_flow_imp.g_varchar2_table(154) := '746164617461203D206D6F64656C2E6765745265636F72644D65746164617461286163746976655265636F72644964293B0A202020202020202020202020202020206D6F64656C5574696C2E7365744669656C6444697361626C6564286D6F64656C2C20';
wwv_flow_imp.g_varchar2_table(155) := '6163746976655265636F726449642C207265634D657461646174612C20627574746F6E436F6C756D6E4E616D652C2064697361626C6564293B0A202020202020202020202020202020206966202867726964566965772E73696E676C65526F774D6F6465';
wwv_flow_imp.g_varchar2_table(156) := '290A202020202020202020202020202020207B0A20202020202020202020202020202020202020206C65742073696E676C65526F7724203D206967242E66696E6428272E27202B20435F49475F5245434F52445F56494557293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(157) := '202020202020202020202073696E676C65526F77242E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974656D4964202B20275F225D27292E70726F70282764697361626C6564272C';
wwv_flow_imp.g_varchar2_table(158) := '2064697361626C6564207C7C2021217265634D657461646174613F2E696E736572746564293B200A202020202020202020202020202020207D0A20202020202020202020202020202020656C73650A202020202020202020202020202020207B0A202020';
wwv_flow_imp.g_varchar2_table(159) := '20202020202020202020202020202020206C65742063656C6C24203D2067726964566965772E76696577242E67726964282767657441637469766543656C6C46726F6D436F6C756D6E4974656D272C20617065782E6974656D286974656D4964292E6E6F';
wwv_flow_imp.g_varchar2_table(160) := '6465293B0A20202020202020202020202020202020202020206966202863656C6C24290A20202020202020202020202020202020202020207B0A20202020202020202020202020202020202020202020202063656C6C242E66696E6428276469762E6C69';
wwv_flow_imp.g_varchar2_table(161) := '6234782D636F6C756D6E2D627574746F6E20627574746F6E27292E70726F70282764697361626C6564272C2064697361626C6564293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A2020202020';
wwv_flow_imp.g_varchar2_table(162) := '202020202020207D0A20202020202020207D0A0A20202020202020202F2F20696D706C656D656E7420746865206974656D20696E74657266616365207370656369666963730A2020202020202020617065782E6974656D2E637265617465286974656D49';
wwv_flow_imp.g_varchar2_table(163) := '642C207B0A2020202020202020202020206974656D5F747970653A202749475F425554544F4E5F434F4C554D4E272C2020200A20202020202020202020202067657456616C756528297B0A2020202020202020202020202020202072657475726E207468';
wwv_flow_imp.g_varchar2_table(164) := '69732E6E6F64652E76616C75653B0A2020202020202020202020207D2C2020202020200A2020202020202020202020202F2F2073657456616C7565206973206E6F74206170706C696361626C65202D2076616C756520697320616C776179732072656164';
wwv_flow_imp.g_varchar2_table(165) := '2D6F6E6C792020202020202020202020202020200A20202020202020202020202064697361626C6528297B0A20202020202020202020202020202020736574427574746F6E44697361626C656453746174652874727565293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(166) := '20207D2C0A202020202020202020202020656E61626C6528297B0A20202020202020202020202020202020736574427574746F6E44697361626C656453746174652866616C7365293B202020202020202020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(167) := '200A2020202020202020202020207D2C0A202020202020202020202020697344697361626C656428297B0A202020202020202020202020202020206C657420627574746F6E497344697361626C6564203D2066616C73653B0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(168) := '20202020206C6574206772696456696577203D20676574477269645669657728293B0A202020202020202020202020202020206C6574206163746976655265636F72644964203D2067726964566965772E6765744163746976655265636F726449642829';
wwv_flow_imp.g_varchar2_table(169) := '3B0A20202020202020202020202020202020696620286163746976655265636F72644964290A202020202020202020202020202020207B0A20202020202020202020202020202020202020206C6574207265634D65746164617461203D20677269645669';
wwv_flow_imp.g_varchar2_table(170) := '65772E6D6F64656C2E6765745265636F72644D65746164617461286163746976655265636F72644964293B0A2020202020202020202020202020202020202020627574746F6E497344697361626C6564203D206D6F64656C5574696C2E6765744669656C';
wwv_flow_imp.g_varchar2_table(171) := '644D65746150726F706572747956616C7565287265634D657461646174612C20627574746F6E436F6C756D6E4E616D652C202764697361626C656427293B0A202020202020202020202020202020207D20202020202020202020202020202020200A2020';
wwv_flow_imp.g_varchar2_table(172) := '202020202020202020202020202072657475726E20627574746F6E497344697361626C65643B0A2020202020202020202020207D2C2020202020200A2020202020202020202020202F2F20646973706C617956616C7565466F722066756E6374696F6E20';
wwv_flow_imp.g_varchar2_table(173) := '77696C6C2062652063616C6C6564206279204150455820746F20676574207468652063656C6C20636F6E74656E740A2020202020202020202020202F2F20736F20746861742077696C6C2062652048544D4C20686572650A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(174) := '646973706C617956616C7565466F722876616C75652C20737461746529207B0A2020202020202020202020202020202072657475726E2072656E646572427574746F6E2876616C75652C2073746174653F2E64697361626C6564293B0A20202020202020';
wwv_flow_imp.g_varchar2_table(175) := '20202020207D0A20202020202020207D293B0A0A20202020202020202F2F20617065782E6974656D2E63726561746528292077696C6C2061646420746865206974656D20746F20617065782E6974656D730A20202020202020202F2F2074686973206F6E';
wwv_flow_imp.g_varchar2_table(176) := '652074686F756768206973206E6F74206E65656465642074686572652C20736F2072656D6F76652069740A202020202020202064656C65746520617065782E6974656D735B6974656D49645D3B0A0A20202020202020202F2F20666F727761726420616E';
wwv_flow_imp.g_varchar2_table(177) := '7920627574746F6E20636C69636B20746F207468652068696464656E20636F6C756D6E206974656D2061732074686174206F6E650A20202020202020202F2F206D69676874206861766520616E792044412061747461636865640A202020202020202069';
wwv_flow_imp.g_varchar2_table(178) := '67242E6F6E2827636C69636B272C20276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974656D4964202B20275F225D272C2066756E6374696F6E286A51756572794576656E74297B0A2020202020';
wwv_flow_imp.g_varchar2_table(179) := '202020202020206C6574206772696456696577203D20676574477269645669657728293B0A2020202020202020202020206C65742064617461203D207B7D3B0A202020202020202020202020646174612E6D6F64656C203D2067726964566965772E6D6F';
wwv_flow_imp.g_varchar2_table(180) := '64656C3B2020202020200A202020202020202020202020646174612E636F6E746578745265636F7264203D2067726964566965772E676574436F6E746578745265636F7264286A51756572794576656E742E63757272656E74546172676574295B305D3B';
wwv_flow_imp.g_varchar2_table(181) := '0A202020202020202020202020646174612E7265636F72644964203D2067726964566965772E6D6F64656C2E6765745265636F7264496428646174612E636F6E746578745265636F7264293B0A202020202020202020202020646174612E696E74657261';
wwv_flow_imp.g_varchar2_table(182) := '63746976654772696456696577203D2067726964566965773B0A202020202020202020202020646174612E636F6E7465787444617461203D206D6F64656C5574696C2E7265636F72644172726179546F4F626A65637428646174612E6D6F64656C2C2064';
wwv_flow_imp.g_varchar2_table(183) := '6174612E636F6E746578745265636F7264293B0A202020202020202020202020617065782E6576656E742E74726967676572286974656D242C2027636C69636B272C2064617461293B0A20202020202020207D293B0A0A20202020202020202F2F20696E';
wwv_flow_imp.g_varchar2_table(184) := '20636173652074686520627574746F6E20697320636F6E646974696F6E616C20656E61626C65642C206C697374656E20746F206D6F64656C206576656E747320617320746F0A20202020202020202F2F2073657420746865206669656C64206D65746164';
wwv_flow_imp.g_varchar2_table(185) := '6174612064697361626C6564206174747269627574650A202020202020202069662028656E61626C65436F6E646974696F6E2026262028656E61626C65436F6E646974696F6E2E636F6C756D6E207C7C20656E61626C65436F6E646974696F6E2E656469';
wwv_flow_imp.g_varchar2_table(186) := '74416C6C6F77656429290A20202020202020207B0A2020202020202020202020206967242E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465222C2066756E6374696F6E286A51756572794576656E742C2064617461';
wwv_flow_imp.g_varchar2_table(187) := '297B200A202020202020202020202020202020206C6574206D6F64656C203D20646174612E6D6F64656C3B0A202020202020202020202020202020206C6574206576616C756174655265636F726473203D2066756E6374696F6E28206368616E67655479';
wwv_flow_imp.g_varchar2_table(188) := '70652C206368616E676520297B0A20202020202020202020202020202020202020206C657420697472203D206368616E67653F2E7265636F726473203F206368616E67652E7265636F726473203A20286368616E67653F2E7265636F7264203F205B6368';
wwv_flow_imp.g_varchar2_table(189) := '616E67652E7265636F72645D203A206D6F64656C293B0A20202020202020202020202020202020202020206974722E666F72456163682866756E6374696F6E20287265636F7264297B0A2020202020202020202020202020202020202020202020206C65';
wwv_flow_imp.g_varchar2_table(190) := '74207265636F72644964203D206D6F64656C2E6765745265636F72644964287265636F7264293B0A2020202020202020202020202020202020202020202020206C657420697344697361626C6564203D2066616C73653B0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(191) := '20202020202020202020202069662028656E61626C65436F6E646974696F6E2E636F6C756D6E290A2020202020202020202020202020202020202020202020207B0A202020202020202020202020202020202020202020202020202020206C657420636F';
wwv_flow_imp.g_varchar2_table(192) := '6E64436F6C756D6E56616C7565203D206D6F64656C5574696C2E6765744E617469766556616C7565286D6F64656C2C207265636F72642C20656E61626C65436F6E646974696F6E2E636F6C756D6E290A2020202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(193) := '2020202020202020697344697361626C6564203D2021706C7567696E5574696C2E6576616C75617465436F6E646974696F6E28656E61626C65436F6E646974696F6E2C20636F6E64436F6C756D6E56616C7565293B0A2020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(194) := '202020202020202020207D0A202020202020202020202020202020202020202020202020697344697361626C6564203D20697344697361626C6564207C7C202028656E61626C65436F6E646974696F6E2E65646974416C6C6F77656420262620216D6F64';
wwv_flow_imp.g_varchar2_table(195) := '656C2E616C6C6F7745646974287265636F726429293B0A2020202020202020202020202020202020202020202020206C6574207265634D65746164617461203D206D6F64656C2E6765745265636F72644D65746164617461287265636F72644964293B0A';
wwv_flow_imp.g_varchar2_table(196) := '2020202020202020202020202020202020202020202020206D6F64656C5574696C2E7365744669656C6444697361626C6564286D6F64656C2C207265636F726449642C207265634D657461646174612C20627574746F6E436F6C756D6E4E616D652C2069';
wwv_flow_imp.g_varchar2_table(197) := '7344697361626C6564293B0A2020202020202020202020202020202020202020202020202F2F2073657474696E67207468652064697361626C656420666C616720696E20746865207265636F7264206669656C64206D6574616461746120776F6E277420';
wwv_flow_imp.g_varchar2_table(198) := '696D706163742074686520627574746F6E20737461746520696E20636173650A2020202020202020202020202020202020202020202020202F2F20746865206368616E6765207479706520697320736574206F6E20616374697665207265636F7264206F';
wwv_flow_imp.g_varchar2_table(199) := '7220696E2063617365206F662064656C6574650A2020202020202020202020202020202020202020202020202F2F20736F20696E2074686F73652063617365732077652077696C6C206E65656420746F20646F206974206F757273656C7665730A202020';
wwv_flow_imp.g_varchar2_table(200) := '202020202020202020202020202020202020202020696620286368616E676554797065203D3D202773657427207C7C206368616E676554797065203D3D202764656C65746527290A2020202020202020202020202020202020202020202020207B0A2020';
wwv_flow_imp.g_varchar2_table(201) := '20202020202020202020202020202020202020202020202020202F2F2067726964566965770A202020202020202020202020202020202020202020202020202020206C657420726F7724203D206967242E66696E6428225B646174612D69643D2722202B';
wwv_flow_imp.g_varchar2_table(202) := '207265636F72644964202B2022275D22293B0A20202020202020202020202020202020202020202020202020202020726F77242E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974';
wwv_flow_imp.g_varchar2_table(203) := '656D4964202B20275F225D27292E70726F70282764697361626C6564272C20697344697361626C6564293B0A202020202020202020202020202020202020202020202020202020202F2F2073696E676C65526F7756696577200A20202020202020202020';
wwv_flow_imp.g_varchar2_table(204) := '2020202020202020202020202020202020202F2F20535256206973206E6F742070726F7065726C792073657474696E67207468652069732D726561646F6E6C7920636C617373206F6E2074686520636F6E7461696E657220647572696E6720696E736572';
wwv_flow_imp.g_varchar2_table(205) := '74206D6F64650A202020202020202020202020202020202020202020202020202020202F2F2075706F6E206669656C6420646561637469766174652C20697420657865637574657320612073657456616C75652077686963682077696C6C206572726F72';
wwv_flow_imp.g_varchar2_table(206) := '0A202020202020202020202020202020202020202020202020202020202F2F20746F2070726576656E742C207765206B6565702069742064697361626C65640A202020202020202020202020202020202020202020202020202020206C65742073696E67';
wwv_flow_imp.g_varchar2_table(207) := '6C65526F7724203D206967242E66696E6428272E27202B20435F49475F5245434F52445F56494557293B0A2020202020202020202020202020202020202020202020202020202073696E676C65526F77242E66696E6428276469762E6C696234782D636F';
wwv_flow_imp.g_varchar2_table(208) := '6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974656D4964202B20275F225D27292E70726F70282764697361626C6564272C2028697344697361626C6564207C7C2021217265634D657461646174613F2E696E73657274656429';
wwv_flow_imp.g_varchar2_table(209) := '293B200A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D293B0A202020202020202020202020202020207D3B0A202020202020202020202020202020206C65742070726F63657373';
wwv_flow_imp.g_varchar2_table(210) := '4F6E4368616E6765203D2066756E6374696F6E286368616E6765547970652C206368616E6765297B0A20202020202020202020202020202020202020206C657420636865636B4368616E67655479706573203D205B2761646444617461272C2027696E73';
wwv_flow_imp.g_varchar2_table(211) := '657274272C2027636F7079272C202764656C657465272C2027726566726573685265636F726473272C2027726576657274275D3B0A202020202020202020202020202020202020202069662028636865636B4368616E676554797065732E696E636C7564';
wwv_flow_imp.g_varchar2_table(212) := '6573286368616E67655479706529207C7C20286368616E676554797065203D3D3D202773657427202626206368616E67652E6669656C64203D3D3D20656E61626C65436F6E646974696F6E2E636F6C756D6E29290A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(213) := '20202020207B0A2020202020202020202020202020202020202020202020206576616C756174655265636F726473286368616E6765547970652C206368616E6765293B0A20202020202020202020202020202020202020207D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(214) := '2020202020207D0A202020202020202020202020202020206576616C756174655265636F72647328276164644461746127293B20202F2F20696E697469616C20736574206F66207265636F7264732028696E2063617365206E6F206C617A79206C6F6164';
wwv_flow_imp.g_varchar2_table(215) := '696E67290A202020202020202020202020202020206D6F64656C2E737562736372696265287B0A20202020202020202020202020202020202020206F6E4368616E67653A2070726F636573734F6E4368616E67650A202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(216) := '207D293B0A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2F2066756E6374696F6E20746F206170706C79206C6162656C2F636C61737320737562737469747574696F6E7320746F206C6962347820636F6C75';
wwv_flow_imp.g_varchar2_table(217) := '6D6E20627574746F6E7320617320666F756E6420696E207468652049470A20202020202020202F2F2069742077696C6C2066696C74657220666F72206E6F7420796574207375627374697475746564206C6162656C732F636C61737365730A2020202020';
wwv_flow_imp.g_varchar2_table(218) := '2020202F2F20616C736F2074686520627574746F6E207469746C652028746F6F6C74697029206D696768742062652074686520726573756C742066726F6D20737562737469747574696F6E0A2020202020202020636F6E7374206170706C795375627374';
wwv_flow_imp.g_varchar2_table(219) := '69747574696F6E73203D202829203D3E207B0A20202020202020202020202066756E6374696F6E206170706C79427574746F6E41747472537562737469747574696F6E2867726964566965772C20617474724E616D65290A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(220) := '7B0A202020202020202020202020202020206C657420627574746F6E53657424203D206967242E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974656D4964202B20275F225D2729';
wwv_flow_imp.g_varchar2_table(221) := '2E66696C7465722866756E6374696F6E2829207B0A202020202020202020202020202020202020202072657475726E2073756273745061747465726E2E7465737428242874686973292E6174747228617474724E616D6529293B0A202020202020202020';
wwv_flow_imp.g_varchar2_table(222) := '202020202020207D293B2020202020202020202020200A20202020202020202020202020202020627574746F6E536574242E656163682866756E6374696F6E28696E6465782C20656C656D656E74297B0A20202020202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(223) := '206C65742074656D706C617465203D202428656C656D656E74292E6174747228617474724E616D65293B0A20202020202020202020202020202020202020206C6574207265636F7264203D2067726964566965772E676574436F6E746578745265636F72';
wwv_flow_imp.g_varchar2_table(224) := '6428656C656D656E74295B305D3B0A20202020202020202020202020202020202020206C6574206174747256616C7565203D20617065782E7574696C2E6170706C7954656D706C6174652874656D706C6174652C207B6D6F64656C3A206D6F64656C2C20';
wwv_flow_imp.g_varchar2_table(225) := '7265636F72643A207265636F72647D293B0A20202020202020202020202020202020202020202428656C656D656E74292E6174747228617474724E616D652C206174747256616C7565293B0A202020202020202020202020202020207D293B0A20202020';
wwv_flow_imp.g_varchar2_table(226) := '20202020202020207D0A0A2020202020202020202020206C6574206772696456696577203D20676574477269645669657728293B0A2020202020202020202020206C6574206D6F64656C203D2067726964566965772E6D6F64656C3B0A20202020202020';
wwv_flow_imp.g_varchar2_table(227) := '2020202020696620286C6162656C5375627374290A2020202020202020202020207B0A202020202020202020202020202020202F2F2066696C746572206E6F6E2D7375627374697475746564206C6162656C730A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(228) := '6C6574206C6162656C53657424203D206967242E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D2227202B206974656D4964202B20275F225D207370616E2E742D427574746F6E2D6C6162656C27';
wwv_flow_imp.g_varchar2_table(229) := '292E66696C7465722866756E6374696F6E2829207B0A202020202020202020202020202020202020202072657475726E2073756273745061747465726E2E7465737428242874686973292E746578742829293B0A20202020202020202020202020202020';
wwv_flow_imp.g_varchar2_table(230) := '7D293B0A202020202020202020202020202020206C6162656C536574242E656163682866756E6374696F6E28696E6465782C20656C656D656E74297B0A20202020202020202020202020202020202020206C65742074656D706C617465203D202428656C';
wwv_flow_imp.g_varchar2_table(231) := '656D656E74292E7465787428293B0A20202020202020202020202020202020202020206C6574207265636F7264203D2067726964566965772E676574436F6E746578745265636F726428656C656D656E74295B305D3B20202020202F2F20616C736F2077';
wwv_flow_imp.g_varchar2_table(232) := '6F726B7320666F72205352560A20202020202020202020202020202020202020206C6574206C6162656C203D20617065782E7574696C2E6170706C7954656D706C6174652874656D706C6174652C207B6D6F64656C3A206D6F64656C2C207265636F7264';
wwv_flow_imp.g_varchar2_table(233) := '3A207265636F72647D29207C7C20636F6C756D6E4C6162656C3B202020202020202020202020202020202020200A20202020202020202020202020202020202020202428656C656D656E74292E74657874286C6162656C293B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(234) := '202020202020202020202428656C656D656E74292E72656D6F76654174747228277374796C6527293B0A202020202020202020202020202020207D293B0A202020202020202020202020202020206170706C79427574746F6E4174747253756273746974';
wwv_flow_imp.g_varchar2_table(235) := '7574696F6E2867726964566965772C20277469746C6527293B202020202020202020202020202020200A2020202020202020202020207D0A20202020202020202020202069662028636C6173735375627374290A2020202020202020202020207B0A2020';
wwv_flow_imp.g_varchar2_table(236) := '20202020202020202020202020206170706C79427574746F6E41747472537562737469747574696F6E2867726964566965772C2027636C61737327293B200A2020202020202020202020207D200A20202020202020207D3B0A0A20202020202020202F2F';
wwv_flow_imp.g_varchar2_table(237) := '206170706C7920616E7920737562737469747574696F6E73206F6E20617070726F707269617465206576656E747320286C6162656C2F63737320636C61737365732C20627574746F6E207469746C65290A2020202020202020696620286C6162656C5375';
wwv_flow_imp.g_varchar2_table(238) := '627374207C7C20636C6173735375627374290A20202020202020207B0A2020202020202020202020206967242E6F6E282267726964706167656368616E6765222C2066756E6374696F6E286A51756572794576656E742C2064617461297B200A20202020';
wwv_flow_imp.g_varchar2_table(239) := '2020202020202020202020206170706C79537562737469747574696F6E7328293B0A2020202020202020202020207D293B0A2020202020202020202020206967242E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465';
wwv_flow_imp.g_varchar2_table(240) := '222C2066756E6374696F6E286A51756572794576656E742C2064617461297B200A202020202020202020202020202020206C6574206D6F64656C203D20646174612E6D6F64656C3B0A202020202020202020202020202020206D6F64656C2E7375627363';
wwv_flow_imp.g_varchar2_table(241) := '72696265287B0A20202020202020202020202020202020202020206F6E4368616E67653A2066756E6374696F6E286368616E6765547970652C206368616E6765297B0A2020202020202020202020202020202020202020202020206C657420636865636B';
wwv_flow_imp.g_varchar2_table(242) := '4368616E67655479706573203D205B27726566726573685265636F726473272C2027726576657274272C2027696E73657274272C2027636F7079275D3B0A20202020202020202020202020202020202020202020202069662028636865636B4368616E67';
wwv_flow_imp.g_varchar2_table(243) := '6554797065732E696E636C75646573286368616E67655479706529290A2020202020202020202020202020202020202020202020207B20202020202020200A202020202020202020202020202020202020202020202020202020202F2F20757365207469';
wwv_flow_imp.g_varchar2_table(244) := '6D656F75742061732041504558206973207374696C6C2079657420746F2063616C6C207468652027646973706C617956616C7565466F7227206D6574686F640A2020202020202020202020202020202020202020202020202020202073657454696D656F';
wwv_flow_imp.g_varchar2_table(245) := '7574286170706C79537562737469747574696F6E732C203130293B0A2020202020202020202020202020202020202020202020207D202020202020202020202020202020200A20202020202020202020202020202020202020207D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(246) := '20202020202020207D293B202020202020202020202020202020200A2020202020202020202020207D293B0A20202020202020207D0A0A20202020202020202F2F20646F6E2774206861766520616E792073696E676C652D726F772D7669657720627574';
wwv_flow_imp.g_varchar2_table(247) := '746F6E20696E207468652053525620697473656C660A2020202020202020696620286F7074696F6E732E616374696F6E203D3D202773696E676C652D726F772D7669657727290A20202020202020207B0A2020202020202020202020206967242E6F6E28';
wwv_flow_imp.g_varchar2_table(248) := '22696E74657261637469766567726964637265617465222C2066756E6374696F6E286A51756572794576656E742C2064617461297B200A20202020202020202020202020202020617065782E6974656D286974656D4964292E6869646528293B0A202020';
wwv_flow_imp.g_varchar2_table(249) := '2020202020202020207D293B0A20202020202020207D0A202020207D0A0A2020202072657475726E7B0A2020202020202020696E69743A20696E69740A202020207D0A202020200A7D2928617065782E6A51756572792C20617065782E7574696C293B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(14352934589589068)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_file_name=>'js/ig-buttoncolumn.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2F2A2A0A202A2040617574686F72204B6172656C20456B656D610A202A20406C6963656E7365204D4954206C6963656E73650A202A20436F70797269676874202863292032303235204B6172656C20456B656D610A202A0A202A205065726D697373696F';
wwv_flow_imp.g_varchar2_table(2) := '6E20697320686572656279206772616E7465642C2066726565206F66206368617267652C20746F20616E7920706572736F6E206F627461696E696E67206120636F70790A202A206F66207468697320736F66747761726520616E64206173736F63696174';
wwv_flow_imp.g_varchar2_table(3) := '656420646F63756D656E746174696F6E2066696C657320287468652027536F66747761726527292C20746F206465616C0A202A20696E2074686520536F66747761726520776974686F7574207265737472696374696F6E2C20696E636C7564696E672077';
wwv_flow_imp.g_varchar2_table(4) := '6974686F7574206C696D69746174696F6E20746865207269676874730A202A20746F207573652C20636F70792C206D6F646966792C206D657267652C207075626C6973682C20646973747269627574652C207375626C6963656E73652C20616E642F6F72';
wwv_flow_imp.g_varchar2_table(5) := '2073656C6C0A202A20636F70696573206F662074686520536F6674776172652C20616E6420746F207065726D697420706572736F6E7320746F2077686F6D2074686520536F6674776172652069730A202A206675726E697368656420746F20646F20736F';
wwv_flow_imp.g_varchar2_table(6) := '2C207375626A65637420746F2074686520666F6C6C6F77696E6720636F6E646974696F6E733A0A202A0A202A205468652061626F766520636F70797269676874206E6F7469636520616E642074686973207065726D697373696F6E206E6F746963652073';
wwv_flow_imp.g_varchar2_table(7) := '68616C6C20626520696E636C7564656420696E20616C6C0A202A20636F70696573206F72207375627374616E7469616C20706F7274696F6E73206F662074686520536F6674776172652E0A202A0A202A2054484520534F4654574152452049532050524F';
wwv_flow_imp.g_varchar2_table(8) := '564944454420274153204953272C20574954484F55542057415252414E5459204F4620414E59204B494E442C2045585052455353204F520A202A20494D504C4945442C20494E434C5544494E4720425554204E4F54204C494D4954454420544F20544845';
wwv_flow_imp.g_varchar2_table(9) := '2057415252414E54494553204F46204D45524348414E544142494C4954592C0A202A204649544E45535320464F52204120504152544943554C415220505552504F534520414E44204E4F4E494E4652494E47454D454E542E20494E204E4F204556454E54';
wwv_flow_imp.g_varchar2_table(10) := '205348414C4C205448450A202A20415554484F5253204F5220434F5059524947485420484F4C44455253204245204C4941424C4520464F5220414E5920434C41494D2C2044414D41474553204F52204F544845520A202A204C494142494C4954592C2057';
wwv_flow_imp.g_varchar2_table(11) := '48455448455220494E20414E20414354494F4E204F4620434F4E54524143542C20544F5254204F52204F54484552574953452C2041524953494E472046524F4D2C0A202A204F5554204F46204F5220494E20434F4E4E454354494F4E2057495448205448';
wwv_flow_imp.g_varchar2_table(12) := '4520534F465457415245204F522054484520555345204F52204F54484552204445414C494E475320494E205448450A202A20534F4654574152452E0A202A2F0A77696E646F772E6C696234783D77696E646F772E6C696234787C7C7B7D2C77696E646F77';
wwv_flow_imp.g_varchar2_table(13) := '2E6C696234782E6178743D77696E646F772E6C696234782E6178747C7C7B7D2C77696E646F772E6C696234782E6178742E69673D77696E646F772E6C696234782E6178742E69677C7C7B7D2C6C696234782E6178742E69672E627574746F6E436F6C756D';
wwv_flow_imp.g_varchar2_table(14) := '6E3D66756E6374696F6E28742C65297B636F6E7374206E3D22612D49472D7265636F726456696577223B6C6574206C3D66756E6374696F6E28742C65297B636F6E73747B747970653A6E2C76616C75653A6C7D3D742C693D4E756D6265722865292C6F3D';
wwv_flow_imp.g_varchar2_table(15) := '4E756D626572286C292C613D6526266C26262169734E614E28692926262169734E614E286F292C723D613F693A652C643D613F6F3A6C3B737769746368286E297B6361736522455155414C223A72657475726E20723D3D3D643B63617365224E4F545F45';
wwv_flow_imp.g_varchar2_table(16) := '5155414C223A72657475726E2072213D3D643B63617365224C455353223A72657475726E20723C643B63617365224C4553535F455155414C223A72657475726E20723C3D643B636173652247524541544552223A72657475726E20723E643B6361736522';
wwv_flow_imp.g_varchar2_table(17) := '475245415445525F455155414C223A72657475726E20723E3D643B63617365224E554C4C223A72657475726E206E756C6C3D3D727C7C22223D3D3D723B63617365224E4F545F4E554C4C223A72657475726E206E756C6C213D7226262222213D3D723B64';
wwv_flow_imp.g_varchar2_table(18) := '656661756C743A7468726F77206E6577204572726F722860556E6B6E6F776E20636F6E646974696F6E20747970653A20247B6E7D60297D7D2C693D7B6765744669656C644D657461646174613A66756E6374696F6E28742C652C6E297B6C6574206C3D6E';
wwv_flow_imp.g_varchar2_table(19) := '756C6C3B69662874297B742E6669656C64737C7C6E262628742E6669656C64733D7B7D293B6C657420693D742E6669656C64733B69262628695B655D7C7C6E262628695B655D3D7B7D292C6C3D695B655D297D72657475726E206C7D2C6765744669656C';
wwv_flow_imp.g_varchar2_table(20) := '644D65746150726F706572747956616C75653A66756E6374696F6E28742C652C6E297B6C6574206C3D6E756C6C2C693D746869732E6765744669656C644D6574616461746128742C652C2131293B72657475726E20692626286C3D695B6E5D292C6C7D2C';
wwv_flow_imp.g_varchar2_table(21) := '7365744669656C644D65746150726F706572747956616C75653A66756E6374696F6E28742C652C6E2C6C2C692C6F297B6966286E297B6E2E6669656C64737C7C286E2E6669656C64733D7B7D293B6C657420613D6E2E6669656C64733B615B6C5D7C7C28';
wwv_flow_imp.g_varchar2_table(22) := '615B6C5D3D7B7D292C615B6C5D5B695D3D6F2C742E6D657461646174614368616E67656428652C6C2C69297D7D2C6765745363616C617256616C75653A66756E6374696F6E28742C652C6E297B6C6574206C3D742E67657456616C756528652C6E293B69';
wwv_flow_imp.g_varchar2_table(23) := '66286E756C6C213D3D6C2626226F626A656374223D3D747970656F66206C26266C2E6861734F776E50726F706572747928227622292626286C3D6C2E762C41727261792E69734172726179286C2929297B6C657420653D742E6765744F7074696F6E2822';
wwv_flow_imp.g_varchar2_table(24) := '6669656C647322295B6E5D2C693D223A223B652626652E656C656D656E7449642626617065782E6974656D28652E656C656D656E744964292E676574536570617261746F72262628693D617065782E6974656D28652E656C656D656E744964292E676574';
wwv_flow_imp.g_varchar2_table(25) := '536570617261746F7228292C697C7C28693D223A2229292C6C3D6C2E6A6F696E285B695D297D72657475726E206C7D2C6765744E617469766556616C75653A66756E6374696F6E28742C652C6E297B6C6574206C3D746869732E6765745363616C617256';
wwv_flow_imp.g_varchar2_table(26) := '616C756528742C652C6E292C693D6C2C6F3D742E6765744F7074696F6E28226669656C647322295B6E5D2C613D6F2E64617461547970653B696628224E554D424552223D3D6129693D6C3F617065782E6C6F63616C652E746F4E756D626572286C2C6F2E';
wwv_flow_imp.g_varchar2_table(27) := '666F726D61744D61736B293A6E756C6C3B656C7365206966282244415445223D3D6129696628693D6E756C6C2C6C297B7472797B693D617065782E646174652E7061727365286C2C6F2E666F726D61744D61736B297D63617463682874297B636F6E736F';
wwv_flow_imp.g_varchar2_table(28) := '6C652E6C6F672822496E76616C696420646174653A20222B6C297D69262628693D617065782E646174652E746F49534F537472696E67286929297D656C736520693D6E756C6C3B72657475726E20697D2C7365744669656C6444697361626C65643A6675';
wwv_flow_imp.g_varchar2_table(29) := '6E6374696F6E28742C652C6E2C6C2C69297B746869732E7365744669656C644D65746150726F706572747956616C756528742C652C6E2C6C2C2264697361626C6564222C69297D2C69735265636F72644669656C643A66756E6374696F6E2874297B7265';
wwv_flow_imp.g_varchar2_table(30) := '7475726E20742E6861734F776E50726F70657274792822696E64657822292626225F6D65746122213D742E70726F70657274797D2C7265636F72644172726179546F4F626A6563743A66756E6374696F6E28742C65297B6C6574206E3D6E756C6C2C6C3D';
wwv_flow_imp.g_varchar2_table(31) := '742E6765744F7074696F6E28226669656C647322293B6966286526266C297B6E3D7B7D3B666F7228636F6E73745B692C6F5D6F66204F626A6563742E656E7472696573286C2929746869732E69735265636F72644669656C64286F292626286E5B695D3D';
wwv_flow_imp.g_varchar2_table(32) := '746869732E6765744E617469766556616C756528742C652C6929297D72657475726E206E7D7D3B72657475726E7B696E69743A66756E6374696F6E286F2C612C722C642C63297B636F6E737420753D2F265B5E2E5D2A5C2E2F3B6C657420733D302C703D';
wwv_flow_imp.g_varchar2_table(33) := '752E7465737428642E6C6162656C292C663D752E7465737428642E637373436C6173736573292C6D3D7B4E4F524D414C3A6E756C6C2C5052494D4152593A22742D427574746F6E2D2D7072696D617279222C5741524E494E473A22742D427574746F6E2D';
wwv_flow_imp.g_varchar2_table(34) := '2D7761726E696E67222C44414E4745523A22742D427574746F6E2D2D64616E676572222C535543434553533A22742D427574746F6E2D2D73756363657373227D2C623D6E756C6C2C673D6E756C6C3B2249434F4E223D3D642E617070656172616E63653F';
wwv_flow_imp.g_varchar2_table(35) := '28623D22742D427574746F6E20742D427574746F6E2D2D6E6F4C6162656C2020742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C222C673D22742D49636F6E20222B642E69636F6E436C617373293A22544558545F574954485F';
wwv_flow_imp.g_varchar2_table(36) := '49434F4E223D3D642E617070656172616E63653F28623D22742D427574746F6E20742D427574746F6E2D2D69636F6E20742D427574746F6E2D2D736D616C6C20742D427574746F6E2D2D69636F6E4C656674222C673D22742D49636F6E20742D49636F6E';
wwv_flow_imp.g_varchar2_table(37) := '2D2D6C65667420222B642E69636F6E436C617373293A623D22742D427574746F6E20742D427574746F6E2D2D736D616C6C222C622B3D6D5B642E747970655D3F2220222B6D5B642E747970655D3A22222C622B3D642E637373436C61737365733F222022';
wwv_flow_imp.g_varchar2_table(38) := '2B642E637373436C61737365733A22223B6C657420783D6E756C6C3B2253545245544348223D3D642E77696474683F783D22646973706C61793A20626C6F636B3B2077696474683A20313030253B223A22504958454C53223D3D642E7769647468262628';
wwv_flow_imp.g_varchar2_table(39) := '783D2277696474683A20222B642E7769647468506978656C732B2270783B22293B636F6E737420773D74286023247B6F7D60292C763D772E636C6F7365737428222E612D47562D636F6C756D6E4974656D436F6E7461696E657222292E636C6F73657374';
wwv_flow_imp.g_varchar2_table(40) := '28226469765B6964243D275F6967275D22293B6C657420793D6E756C6C3B636F6E737420523D28293D3E28797C7C28793D772E636C6F7365737428222E612D494722292E696E746572616374697665477269642822676574566965777322292E67726964';
wwv_flow_imp.g_varchar2_table(41) := '292C79292C683D743D3E7B6C657420653D5228292C6C3D652E6D6F64656C2C723D652E6765744163746976655265636F7264496428293B69662872297B6C657420643D6C2E6765745265636F72644D657461646174612872293B696628692E7365744669';
wwv_flow_imp.g_varchar2_table(42) := '656C6444697361626C6564286C2C722C642C612C74292C652E73696E676C65526F774D6F6465297B762E66696E6428222E222B6E292E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D22272B6F2B';
wwv_flow_imp.g_varchar2_table(43) := '275F225D27292E70726F70282264697361626C6564222C747C7C2121643F2E696E736572746564297D656C73657B6C6574206E3D652E76696577242E67726964282267657441637469766543656C6C46726F6D436F6C756D6E4974656D222C617065782E';
wwv_flow_imp.g_varchar2_table(44) := '6974656D286F292E6E6F6465293B6E26266E2E66696E6428226469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E22292E70726F70282264697361626C6564222C74297D7D7D3B617065782E6974656D2E637265617465286F2C7B';
wwv_flow_imp.g_varchar2_table(45) := '6974656D5F747970653A2249475F425554544F4E5F434F4C554D4E222C67657456616C756528297B72657475726E20746869732E6E6F64652E76616C75657D2C64697361626C6528297B68282130297D2C656E61626C6528297B68282131297D2C697344';
wwv_flow_imp.g_varchar2_table(46) := '697361626C656428297B6C657420743D21312C653D5228292C6E3D652E6765744163746976655265636F7264496428293B6966286E297B6C6574206C3D652E6D6F64656C2E6765745265636F72644D65746164617461286E293B743D692E676574466965';
wwv_flow_imp.g_varchar2_table(47) := '6C644D65746150726F706572747956616C7565286C2C612C2264697361626C656422297D72657475726E20747D2C646973706C617956616C7565466F723A28742C6E293D3E2828742C6E293D3E7B6C6574206C3D5228292C693D21216C2E73696E676C65';
wwv_flow_imp.g_varchar2_table(48) := '526F774D6F64652C613D6E756C6C3B69662869262628613D6C2E73696E676C65526F7756696577242E7265636F7264566965772822696E7374616E636522292E63757272656E745265636F726449642C612626216E29297B6C657420743D6C2E6D6F6465';
wwv_flow_imp.g_varchar2_table(49) := '6C2E6765745265636F72644D657461646174612861293B6E3D2121743F2E696E7365727465647D6C657420633D642E6C6162656C7C7C742C6D3D623B69662869262661262628707C7C6629297B6C657420743D7B6D6F64656C3A6C2E6D6F64656C2C7265';
wwv_flow_imp.g_varchar2_table(50) := '636F72643A6C2E6D6F64656C2E6765745265636F72642861297D3B70262628633D617065782E7574696C2E6170706C7954656D706C61746528632C7429292C662626286D3D617065782E7574696C2E6170706C7954656D706C617465286D2C7429297D63';
wwv_flow_imp.g_varchar2_table(51) := '7C7C28633D72293B636F6E737420773D652E68746D6C4275696C64657228293B72657475726E20772E6D61726B757028223C64697622292E617474722822636C617373222C226C696234782D636F6C756D6E2D627574746F6E22292E6D61726B75702822';
wwv_flow_imp.g_varchar2_table(52) := '3E3C627574746F6E22292E6F7074696F6E616C4174747228227374796C65222C693F6E756C6C3A78292E617474722822636C617373222C6D292E61747472282274797065222C22627574746F6E22292E6174747228226964222C60247B6F7D5F247B737D';
wwv_flow_imp.g_varchar2_table(53) := '5F3060292E6F7074696F6E616C417474722822646174612D616374696F6E222C642E616374696F6E292E6F7074696F6E616C4174747228227469746C65222C2249434F4E223D3D642E617070656172616E63653F633A6E756C6C292E6F7074696F6E616C';
wwv_flow_imp.g_varchar2_table(54) := '41747472282264697361626C6564222C6E292E6D61726B757028223E22292C672626772E6D61726B757028223C7370616E22292E617474722822636C617373222C67292E6D61726B757028223E3C2F7370616E3E22292C642E617070656172616E63652E';
wwv_flow_imp.g_varchar2_table(55) := '696E636C7564657328225445585422292626772E6D61726B757028223C7370616E22292E617474722822636C617373222C22742D427574746F6E2D6C6162656C22292E6F7074696F6E616C4174747228227374796C65222C752E746573742863293F2264';
wwv_flow_imp.g_varchar2_table(56) := '6973706C61793A6E6F6E65223A6E756C6C292E6D61726B757028223E22292E636F6E74656E742863292E6D61726B757028223C2F7370616E3E22292C772E6D61726B757028223C2F627574746F6E3E3C2F6469763E22292C732B3D312C772E746F537472';
wwv_flow_imp.g_varchar2_table(57) := '696E6728297D2928742C6E3F2E64697361626C6564297D292C64656C65746520617065782E6974656D735B6F5D2C762E6F6E2822636C69636B222C276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D22272B6F2B';
wwv_flow_imp.g_varchar2_table(58) := '275F225D272C2866756E6374696F6E2874297B6C657420653D5228292C6E3D7B7D3B6E2E6D6F64656C3D652E6D6F64656C2C6E2E636F6E746578745265636F72643D652E676574436F6E746578745265636F726428742E63757272656E74546172676574';
wwv_flow_imp.g_varchar2_table(59) := '295B305D2C6E2E7265636F726449643D652E6D6F64656C2E6765745265636F72644964286E2E636F6E746578745265636F7264292C6E2E696E74657261637469766547726964566965773D652C6E2E636F6E74657874446174613D692E7265636F726441';
wwv_flow_imp.g_varchar2_table(60) := '72726179546F4F626A656374286E2E6D6F64656C2C6E2E636F6E746578745265636F7264292C617065782E6576656E742E7472696767657228772C22636C69636B222C6E297D29292C63262628632E636F6C756D6E7C7C632E65646974416C6C6F776564';
wwv_flow_imp.g_varchar2_table(61) := '292626762E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465222C2866756E6374696F6E28742C65297B6C657420723D652E6D6F64656C2C643D66756E6374696F6E28742C65297B28653F2E7265636F7264733F652E';
wwv_flow_imp.g_varchar2_table(62) := '7265636F7264733A653F2E7265636F72643F5B652E7265636F72645D3A72292E666F7245616368282866756E6374696F6E2865297B6C657420643D722E6765745265636F726449642865292C753D21313B696628632E636F6C756D6E297B6C657420743D';
wwv_flow_imp.g_varchar2_table(63) := '692E6765744E617469766556616C756528722C652C632E636F6C756D6E293B753D216C28632C74297D753D757C7C632E65646974416C6C6F776564262621722E616C6C6F77456469742865293B6C657420733D722E6765745265636F72644D6574616461';
wwv_flow_imp.g_varchar2_table(64) := '74612864293B696628692E7365744669656C6444697361626C656428722C642C732C612C75292C22736574223D3D747C7C2264656C657465223D3D74297B762E66696E6428225B646174612D69643D27222B642B22275D22292E66696E6428276469762E';
wwv_flow_imp.g_varchar2_table(65) := '6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D22272B6F2B275F225D27292E70726F70282264697361626C6564222C75292C762E66696E6428222E222B6E292E66696E6428276469762E6C696234782D636F6C756D6E2D62';
wwv_flow_imp.g_varchar2_table(66) := '7574746F6E20627574746F6E5B69645E3D22272B6F2B275F225D27292E70726F70282264697361626C6564222C757C7C2121733F2E696E736572746564297D7D29297D3B6428226164644461746122292C722E737562736372696265287B6F6E4368616E';
wwv_flow_imp.g_varchar2_table(67) := '67653A66756E6374696F6E28742C65297B285B2261646444617461222C22696E73657274222C22636F7079222C2264656C657465222C22726566726573685265636F726473222C22726576657274225D2E696E636C756465732874297C7C22736574223D';
wwv_flow_imp.g_varchar2_table(68) := '3D3D742626652E6669656C643D3D3D632E636F6C756D6E2926266428742C65297D7D297D29293B636F6E737420413D28293D3E7B66756E6374696F6E206528652C6E297B762E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20';
wwv_flow_imp.g_varchar2_table(69) := '627574746F6E5B69645E3D22272B6F2B275F225D27292E66696C746572282866756E6374696F6E28297B72657475726E20752E7465737428742874686973292E61747472286E29297D29292E65616368282866756E6374696F6E28692C6F297B6C657420';
wwv_flow_imp.g_varchar2_table(70) := '613D74286F292E61747472286E292C723D652E676574436F6E746578745265636F7264286F295B305D2C643D617065782E7574696C2E6170706C7954656D706C61746528612C7B6D6F64656C3A6C2C7265636F72643A727D293B74286F292E6174747228';
wwv_flow_imp.g_varchar2_table(71) := '6E2C64297D29297D6C6574206E3D5228292C6C3D6E2E6D6F64656C3B69662870297B762E66696E6428276469762E6C696234782D636F6C756D6E2D627574746F6E20627574746F6E5B69645E3D22272B6F2B275F225D207370616E2E742D427574746F6E';
wwv_flow_imp.g_varchar2_table(72) := '2D6C6162656C27292E66696C746572282866756E6374696F6E28297B72657475726E20752E7465737428742874686973292E746578742829297D29292E65616368282866756E6374696F6E28652C69297B6C6574206F3D742869292E7465787428292C61';
wwv_flow_imp.g_varchar2_table(73) := '3D6E2E676574436F6E746578745265636F72642869295B305D2C643D617065782E7574696C2E6170706C7954656D706C617465286F2C7B6D6F64656C3A6C2C7265636F72643A617D297C7C723B742869292E746578742864292C742869292E72656D6F76';
wwv_flow_imp.g_varchar2_table(74) := '654174747228227374796C6522297D29292C65286E2C227469746C6522297D66262665286E2C22636C61737322297D3B28707C7C6629262628762E6F6E282267726964706167656368616E6765222C2866756E6374696F6E28742C65297B4128297D2929';
wwv_flow_imp.g_varchar2_table(75) := '2C762E6F6E2822696E74657261637469766567726964766965776D6F64656C637265617465222C2866756E6374696F6E28742C65297B652E6D6F64656C2E737562736372696265287B6F6E4368616E67653A66756E6374696F6E28742C65297B5B227265';
wwv_flow_imp.g_varchar2_table(76) := '66726573685265636F726473222C22726576657274222C22696E73657274222C22636F7079225D2E696E636C75646573287429262673657454696D656F757428412C3130297D7D297D2929292C2273696E676C652D726F772D76696577223D3D642E6163';
wwv_flow_imp.g_varchar2_table(77) := '74696F6E2626762E6F6E2822696E74657261637469766567726964637265617465222C2866756E6374696F6E28742C65297B617065782E6974656D286F292E6869646528297D29297D7D7D28617065782E6A51756572792C617065782E7574696C293B';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(14864210100699404)
,p_plugin_id=>wwv_flow_imp.id(14340999435589023)
,p_file_name=>'js/ig-buttoncolumn.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
