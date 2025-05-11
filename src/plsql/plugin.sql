--------------------------------------------------------------------------------
-- t_item_attr type definition
--------------------------------------------------------------------------------
type t_item_attr is record
( 
    c_name                      varchar2(30),
    c_session_state_name        varchar2(30),    
    c_appearance                varchar2(15),
    c_icon                      varchar2(100),
    c_label                     varchar2(50),
    c_type                      varchar(15),
    c_width                     varchar(15),
    c_width_px                  varchar(5),
    c_css_classes               varchar2(150),    
    c_action                    varchar2(100),
    c_enable_cond_column        varchar2(50),
    c_enable_cond_type          varchar2(20),
    c_enable_cond_value         varchar2(50),
    c_enable_cond_edit_allowed  varchar2(1)
); 

--------------------------------------------------------------------------------
-- init_item_attr Procedure
--------------------------------------------------------------------------------
procedure init_item_attr(
    p_item    in  apex_plugin.t_item,
    item_attr out t_item_attr
)
is
begin
    item_attr.c_name                        := apex_plugin.get_input_name_for_item;
    item_attr.c_session_state_name          := p_item.session_state_name;
    item_attr.c_appearance                  := p_item.attributes.get_varchar2('attr_appearance');    
    item_attr.c_icon                        := p_item.attributes.get_varchar2('attr_icon');
    item_attr.c_label                       := p_item.attributes.get_varchar2('attr_label');    
    item_attr.c_type                        := p_item.attributes.get_varchar2('attr_type');
    item_attr.c_width                       := p_item.attributes.get_varchar2('attr_width');
    item_attr.c_width_px                    := p_item.attributes.get_varchar2('attr_width_px');
    item_attr.c_css_classes                 := p_item.attributes.get_varchar2('attr_css_classes');
    item_attr.c_action                      := p_item.attributes.get_varchar2('attr_action');    
    item_attr.c_enable_cond_column          := p_item.attributes.get_varchar2('attr_enable_cond_column');
    item_attr.c_enable_cond_type            := p_item.attributes.get_varchar2('attr_enable_cond_type');
    item_attr.c_enable_cond_value           := p_item.attributes.get_varchar2('attr_enable_cond_value');
    item_attr.c_enable_cond_edit_allowed    := p_item.attributes.get_varchar2('attr_enable_cond_edit_allowed');
end init_item_attr;

--------------------------------------------------------------------------------
-- Render Procedure
-- Adds on-load js as to init the button column client-side
--------------------------------------------------------------------------------
procedure render_ig_button (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_render_param,
    p_result in out nocopy apex_plugin.t_item_render_result
)
is
    item_attr           t_item_attr;
    
    function get_icon_class(p_icon_name in varchar2) return varchar2 
    is
    begin
        if p_icon_name like 'fa-%' then
            return 't-Icon fa ' || p_icon_name;
        elsif p_icon_name like 'icon-%' then
            return 'a-Icon ' || p_icon_name;
        else
            return null;
        end if;
    end;    
begin
    apex_plugin_util.debug_page_item(p_plugin => p_plugin, p_page_item => p_item);
    init_item_attr(p_item, item_attr);
    -- p_param.is_readonly will be true as attribute 'session state changable' is not checked
    -- p_param.is_readonly being true, APEX will create a hidden input element with id as p_item.name  

    -- When specifying the library declaratively, it fails to load the minified version. So using the API:
    apex_javascript.add_library(
          p_name      => 'ig-buttoncolumn',
          p_check_to_add_minified => true,
          --p_directory => '#WORKSPACE_FILES#javascript/',            
          p_directory => p_plugin.file_prefix || 'js/',
          p_version   => NULL
    );                

    -- page on load: init buttonColumn
    apex_javascript.add_onload_code(
        p_code => apex_string.format(
            'lib4x.axt.ig.buttonColumn.init("%s", "%s", "%s", {appearance: "%s", iconClass: "%s", label: "%s", type: "%s", width: "%s", widthPixels: "%s", cssClasses: "%s", action: "%s"}, {column: "%s", type: "%s", value: "%s", editAllowed: %s});'
            , p_item.name 
            , p_item.session_state_name   
            , p_item.label          
            , item_attr.c_appearance
            , get_icon_class(item_attr.c_icon)
            , item_attr.c_label      
            , item_attr.c_type   
            , item_attr.c_width 
            , item_attr.c_width_px 
            , item_attr.c_css_classes   
            , item_attr.c_action 
            , item_attr.c_enable_cond_column
            , item_attr.c_enable_cond_type            
            , item_attr.c_enable_cond_value
            , case item_attr.c_enable_cond_edit_allowed when 'Y' then 'true' else 'false' end
        )
    );

end render_ig_button;

--------------------------------------------------------------------------------
-- Meta Data Procedure
--------------------------------------------------------------------------------
procedure metadata_ig_button (
    p_item   in            apex_plugin.t_item,
    p_plugin in            apex_plugin.t_plugin,
    p_param  in            apex_plugin.t_item_meta_data_param,
    p_result in out nocopy apex_plugin.t_item_meta_data_result )
is
    item_attr   t_item_attr;     
begin
    init_item_attr(p_item, item_attr);
    p_result.return_display_value := false;  -- return 'return' value only for regular item display                                  
    p_result.escape_output := false;
end metadata_ig_button;




