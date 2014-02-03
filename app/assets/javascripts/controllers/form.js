/*
  Please include protos.js before using this
*/

$.Controller("FormController",{

  init:function(){
    this.setup_validation()
    this.setup_submit()
  },

  setup_validation: function() {
    this.validator = this.form.validate({
      ignore: "",
      highlight: function(el, e_cls) {
        $(el).addClass(e_cls);
      },
      unhighlight: function(el, e_cls) {
        $(el).removeClass(e_cls);
      },
      errorPlacement: function(err,el) {
          
      },
      onkeyup: false,
      onfocusout: false,
      focusCleanup: true,
      focusInvalid: false,
      minlength:3
    });
  },

  setup_submit:function(){
    console.log("You can redifine this method and submit method")
  },
  
  ".submit -> click":function(ev){
    ev.preventDefault()
    if(this.form.valid())
      this.submit_from()
  },
  ".reset -> click":function(ev){
    ev.preventDefault()
    this.element.find("input, textarea").val("");
  },
  show_errors:function(text){
    text = text || "error"
    console.log(text)
  },

  submit_:function(){
    this.submit_from()
  },
  
  submit_from:function(){
      self = this
      $.ajax({
        url:      self.form.attr("action"),
        data:     self.form.serialize() + "&map_search=" + self.parent.map_search,
        type:     "post",
        dataType: "json",

        success:function(resp){
          resp.success ? self.success_call_back(resp) : self.failure_call_back(resp);            
        }
      });
  },

  /* ajax callbacs you must redifine in your controller*/

  success_call_back:function(){
    console.error("Redefine this method")
  },
  failure_call_back:function(){
    console.error("Redefine this method")
  },
  /******************************************************/



 
  /* Reg exp classes for inputs*/


  special_test:function(ev,test){
    el = $(ev.target)
    el.val(el.val().replace(test, ""))
  },
  ".only_chars -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-ЯA-zA-Z]/, ""))
  },
  ".only_chars_and_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-ЯA-zA-Z0-9]/, ""))
  },
  ".only_cyrylic -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-Я]/, ""))
  },
  ".only_latin -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^a-zA-Z]/, ""))
  },
  ".only_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9]/, ""))
  },
  ".only_latin_with_spaces -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^a-zA-Z\s]/, ""))
  },
  ".only_cyrylic_with_spaces -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^а-яА-Я\s]/, ""))
  },
  ".without_spaces -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/\s/, ""))
  },
  ".latin_with_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9a-zA-Z]/, ""))
  },
  ".latin_with_numbers_and_spaces -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9a-zA-Z\s]/, ""))
  },
  ".cyrylic_with_numbers -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9а-яА-Я]/, ""))
  },
  ".cyrylic_with_numbers_and_spaces -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().replace(/[^0-9а-яА-я\s]/, ""))
  },
  ".translit_to_latin -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().translit())
  },
  ".translit_to_cyrulic -> keyup":function(ev){
    el = $(ev.target)
    el.val(el.val().de_translit())
  },
  ".max_chars -> keyup":function(ev){
    el = $(ev.target)
    // TODO
    el.val().length
  },




  /*************************************************************/

});