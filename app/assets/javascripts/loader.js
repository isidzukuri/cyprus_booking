;(function($){
    
    $.ajaxformbar = function(e, o){
        
        this.options = $.extend({
            text: 'Ищу...',
            id:  0,
            loaders: new Array(),
            type: 'post',
            start: 3,
            step: 0.3,
            limit: 100,
            startSpeed: 300,
            endSpeed: 1,
            beforeSend: function(){},
            success: function(){},
            after: function(){},
            error: function(){}
        }, o || {});
                
        this.el = $(e);        
                
        this.save_shadow = $('<div data-train-el="'+ this.options.id +'" class="save_shadow"/>');
        this.save_wrap = $('<div data-train-el="'+ this.options.id +'" class="save_wrap"/>');
        this.save_bar = $('<div data-train-el="'+ this.options.id +'" class="save_bar">'+this.options.text+'</div>');
        this.progress_status = 0;
        this.interval = null;
      
        this.init();
    };
    

    $.ajaxformbar.prototype = {
               
        
        init: function(){
            for(i in this.options.loaders){
              id = this.options.loaders[i]           
            }           
            
            $('body').append(
                this.save_shadow,
                this.save_wrap.append(this.save_bar)
            );
            
            this.save_bar.css('width',this.options.start+'%');
            
            var self = this;
            
            this.el.bind('submit.progressbar',function(e){
                
                e.preventDefault();
                self._send_ajax(self.el.attr('action'),self.el.serialize());
                
            });
            
            
            this.html = new Array(this.save_wrap , this.save_shadow );
            
        },
        
        
        _send_ajax: function(url,data){
        
            var self = this;
            $.ajaxPrefilter(function( options, originalOptions, jqXHR ) {
              if(options.crossDomain){
                options.url = options.url.replace(options.url.split("/")[2],window.location.host)
                jqXHR.setRequestHeader('X-Requested-With','XMLHttpRequest')
              }
            })
        	$.ajax({
                url: url,
                type: self.options.type,
                data: data,
                beforeSend: function(jqXHR, settings){
      
                    var status = self.options.beforeSend.apply(self.el,[jqXHR, settings]);
                    
                    if(status !== false) self._show();
                    
                    return status;
               },
                success: function(response, textStatus, jqXHR){

                    self.options.success.apply(self.el,[response, textStatus, jqXHR]);
               },
               complete : function(response,status){
                 
            	   self._hide(status,response.responseText);            	   
               },
                error: function (xhr, ajaxOptions, thrownError) {
                  self.options.error.apply(self.el,[xhr, ajaxOptions, thrownError]);
                }
        	});
        },
        
        _show: function(){
        
            this.save_shadow.show();
            this.save_wrap.show();
            
            var self = this;
            
            self.progress_status = self.options.start;
    
            self.interval = setInterval(function(){
                
                self.progress_status += self.options.step;
                
                self.save_bar.css('width',self.progress_status+'%');
                
                if(self.progress_status >= self.options.limit){
                    
                    clearInterval(self.interval);
                }
                
            },self.options.startSpeed);
           
        },
        
        
        _hide: function(status,resp){

            var self = this;
            
            clearInterval(self.interval);
            
            self.interval = setInterval(function(){
                
                self.progress_status += self.options.step;
                self.save_bar.css('width',self.progress_status+'%');
                
                if(self.progress_status >=100){
                    
                    clearInterval(self.interval);
    
                    self.save_shadow.hide();
                    self.save_wrap.hide();
                    
                    self.progress_status = 0;
                    self.save_bar.css('width',self.progress_status+'%');
                    self.options.after.apply(self.el,[resp,status]);
                }
                
            },self.options.endSpeed);

        }
    };
    
    $.fn.ajaxformbar = function(o){
       
        return this.each(function() {
            
            var instance = $(this).data('ajaxformbar');

            if (typeof instance == 'undefined') {

                $(this).data('ajaxformbar', new $.ajaxformbar(this, o));
            }
        });
        
    };   
    
    
})(jQuery);