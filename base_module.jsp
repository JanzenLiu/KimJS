<script>
    function BaseTemplate(obj){
        /**
         *  @param  obj {
         *      template_str: "<div></div>"                 HTML string
         *      childMap:   {"div": {}}
         *  }
         *  @return templateObject {
         *      elem: <tag></tag>                           HTML element
         *      attrs: {key: value},                        dictionary for attributes
         *      sub_templates: [Template],                  list of Template objects
         *      functions: [{func_name: function(){}}],     list of objects mapping functions and their names
         *      events: [{event_name: function(){}}],       list of objects mapping event names and their related functions
         *  } */
        // TODO: add assertion/checking and error handling
        var _template_str = obj.template_str;   // static variable, inaccessible by user
        if(!_template_str){
            // log message...
            return;
        }
        var elem = $(_template_str);    // create element using template html string
        var childMap = obj.childMap? obj.childMap:[];

        // ----- init sub-template list and bind UI -----
        var sub_temps = [];
        if(childMap && $.isEmptyObject(childMap)) {
            $.each(childMap, function (key, value) {
                elem.find(key).each(function(){
                    if(!value.elem) { return; }  // skip child without valid binding element
                    this.empty().append(value.elem);    // bind UI
                    var child = new BaseTemplate(value);    // init Template object
                    sub_temps.push(child);
                });
            });
        }
        
        var ret = {
            // ----- attributes -----
            elem: elem,  // dependent
            template_str: obj.template_str? obj.template_str: "",
            attrs: obj.attrs? obj.attrs:{},   // independent
            sub_templates: sub_temps,   //
            functions: obj.functions? obj.functions:[],  // user-defined, may be dependent
            events: obj.events? obj.events:[], // user-defined, may be dependent

            // methods
            _initUI: obj.initUI? obj.initUI:null,
            initUI: function(){
                // --- init UI of sub-templates first ---
                $.each(this.sub_templates, function(index, template){
                    template.initUI();
                });

                // --- init UI for itself ---
                if(this._initUI) {
                    this._initUI();
                }
            },
            emptyUI: function(){
                // to be define...
            },
            resetUI: function(){},
            fillData: function(){},
            collectData: function(){},
            setAttrs: function(name, value){
                if(name) { this.attrs[name] = value; }
            },
            enableEditing: function(){},
            disableEditing: function(){},
            setFunction: function(){},
            removeFunction: function(){},
            emptyFunctions: function(){},
            setEvent: function(){},
            removeEvent: function(){},
            emptyEvents: function(){}
        };

        return ret;
    }
</script>