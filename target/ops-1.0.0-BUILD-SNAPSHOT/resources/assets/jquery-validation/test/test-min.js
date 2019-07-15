if(window.sessionStorage){sessionStorage.clear()}jQuery.validator.defaults.debug=true;$.mockjaxSettings.log=$.noop;$.mockjax({url:"form.php?user=Peter&password=foobar",responseText:"Hi Peter, welcome back.",responseStatus:200,responseTime:1});$.mockjax({url:"users.php",data:{username:/Peter2?|asdf/},responseText:"false",responseStatus:200,responseTime:1});$.mockjax({url:"users2.php",data:{username:"asdf"},responseText:'"asdf is already taken, please try something else"',responseStatus:200,responseTime:1});$.mockjax({url:"echo.php",response:function(a){this.responseText=JSON.stringify(a.data)},responseTime:100});module("validator");test("Constructor",function(){var b=$("#testForm1").validate();var a=$("#testForm1").validate();equal(b,a,"Calling validate() multiple times must return the same validator instance");equal(b.elements().length,3,"validator elements")});test("validate() without elements, with non-form elements",0,function(){$("#doesntexist").validate()});test("valid() plugin method",function(){var b=$("#userForm");b.validate();ok(!b.valid(),"Form isn't valid yet");var a=$("#username");ok(!a.valid(),"Input isn't valid either");a.val("Hello world");ok(b.valid(),"Form is now valid");ok(a.valid(),"Input is valid, too")});test("valid() plugin method",function(){var b=$("#testForm1");b.validate();var a=b.find("input");ok(!a.valid(),"all invalid");a.not(":first").val("ok");strictEqual(a.valid(),false,"just one invalid");a.val("ok");strictEqual(a.valid(),true,"all valid")});test("valid() plugin method, special handling for checkable groups",function(){var a=$("#checkable2");ok(!a.valid(),"must be invalid, not checked yet");a.attr("checked",true);ok(a.valid(),"valid, is now checked");a.attr("checked",false);ok(!a.valid(),"invalid again");$("#checkable3").attr("checked",true);ok(a.valid(),"valid, third box is checked")});test("addMethod",function(){expect(3);$.validator.addMethod("hi",function(c){return c==="hi"},"hi me too");var b=$.validator.methods.hi,a=$("#text1")[0];ok(!b(a.value,a),"Invalid");a.value="hi";ok(b(a.value,a),"Invalid");ok(jQuery.validator.messages.hi==="hi me too","Check custom message")});test("addMethod2",function(){expect(4);$.validator.addMethod("complicatedPassword",function(e,d,f){return this.optional(d)||/\D/.test(e)&&/\d/.test(e)},"Your password must contain at least one number and one letter");var a=jQuery("#form").validate({rules:{action:{complicatedPassword:true}}});var c=$.validator.methods.complicatedPassword,b=$("#text1")[0];b.value="";strictEqual(a.element(b),true,"Rule is optional, valid");equal(0,a.size());b.value="ko";ok(!a.element(b),"Invalid, doesn't contain one of the required characters");b.value="ko1";ok(a.element(b))});test("form(): simple",function(){expect(2);var b=$("#testForm1")[0];var a=$(b).validate();ok(!a.form(),"Invalid form");$("#firstname").val("hi");$("#lastname").val("hi");ok(a.form(),"Valid form")});test("form(): checkboxes: min/required",function(){expect(3);var b=$("#testForm6")[0];var a=$(b).validate();ok(!a.form(),"Invalid form");$("#form6check1").attr("checked",true);ok(!a.form(),"Invalid form");$("#form6check2").attr("checked",true);ok(a.form(),"Valid form")});test("form(): radio buttons: required",function(){expect(6);var b=$("#testForm10")[0];var a=$(b).validate({rules:{testForm10Radio:"required"}});ok(!a.form(),"Invalid Form");equal($("#testForm10Radio1").attr("class"),"error");equal($("#testForm10Radio2").attr("class"),"error");$("#testForm10Radio2").attr("checked",true);ok(a.form(),"Valid form");equal($("#testForm10Radio1").attr("class"),"valid");equal($("#testForm10Radio2").attr("class"),"valid")});test("form(): selects: min/required",function(){expect(3);var b=$("#testForm7")[0];var a=$(b).validate();ok(!a.form(),"Invalid form");$("#optionxa").attr("selected",true);ok(!a.form(),"Invalid form");$("#optionxb").attr("selected",true);ok(a.form(),"Valid form")});test("form(): with equalTo",function(){expect(2);var b=$("#testForm5")[0];var a=$(b).validate();ok(!a.form(),"Invalid form");$("#x1, #x2").val("hi");ok(a.form(),"Valid form")});test("form(): with equalTo and onfocusout=false",function(){expect(4);var b=$("#testForm5")[0];var a=$(b).validate({onfocusout:false,showErrors:function(){ok(true,"showErrors should only be called twice");this.defaultShowErrors()}});$("#x1, #x2").val("hi");ok(a.form(),"Valid form");$("#x2").val("not equal").blur();ok(!a.form(),"Invalid form")});test("check(): simple",function(){expect(3);var b=$("#firstname")[0];var a=$("#testForm1").validate();ok(a.size()===0,"No errors yet");a.check(b);ok(a.size()===1,"error exists");a.errorList=[];$("#firstname").val("hi");a.check(b);ok(a.size()===0,"No more errors")});test("hide(): input",function(){expect(3);var c=$("#errorFirstname");var b=$("#firstname")[0];b.value="bla";var a=$("#testForm1").validate();c.show();ok(c.is(":visible"),"Error label visible before validation");ok(a.element(b));ok(c.is(":hidden"),"Error label not visible after validation")});test("hide(): radio",function(){expect(2);var c=$("#agreeLabel");var b=$("#agb")[0];b.checked=true;var a=$("#testForm2").validate({errorClass:"xerror"});c.show();ok(c.is(":visible"),"Error label visible after validation");a.element(b);ok(c.is(":hidden"),"Error label not visible after hiding it")});test("hide(): errorWrapper",function(){expect(2);var c=$("#errorWrapper");var b=$("#meal")[0];b.selectedIndex=1;c.show();ok(c.is(":visible"),"Error label visible after validation");var a=$("#testForm3").validate({wrapper:"li",errorLabelContainer:$("#errorContainer")});a.element(b);ok(c.is(":hidden"),"Error label not visible after hiding it")});test("hide(): container",function(){expect(4);var c=$("#errorContainer");var b=$("#testForm3")[0];var a=$("#testForm3").validate({errorWrapper:"li",errorContainer:$("#errorContainer")});a.form();ok(c.is(":visible"),"Error label visible after validation");$("#meal")[0].selectedIndex=1;a.form();ok(c.is(":hidden"),"Error label not visible after hiding it");$("#meal")[0].selectedIndex=-1;a.element("#meal");ok(c.is(":visible"),"Error label visible after validation");$("#meal")[0].selectedIndex=1;a.element("#meal");ok(c.is(":hidden"),"Error label not visible after hiding it")});test("valid()",function(){expect(4);var b=[{name:"meal",message:"foo",element:$("#meal")[0]}];var a=$("#testForm3").validate();ok(a.valid(),"No errors, must be valid");a.errorList=b;ok(!a.valid(),"One error, must be invalid");QUnit.reset();a=$("#testForm3").validate({submitHandler:function(){ok(false,"Submit handler was called")}});ok(a.valid(),"No errors, must be valid and returning true, even with the submit handler");a.errorList=b;ok(!a.valid(),"One error, must be invalid, no call to submit handler")});test("submitHandler keeps submitting button",function(){$("#userForm").validate({debug:true,submitHandler:function(c){var d=$(c).find("input:hidden")[0];deepEqual(d.value,a.value);deepEqual(d.name,a.name)}});$("#username").val("bla");var a=$("#userForm :submit")[0];var b=$.Event("click");b.preventDefault();$.event.trigger(b,null,a);$("#userForm").submit()});test("showErrors()",function(){expect(4);var c=$("#errorFirstname").hide();var b=$("#firstname")[0];var a=$("#testForm1").validate();ok(c.is(":hidden"));equal(0,$("label.error[for=lastname]").size());a.showErrors({firstname:"required",lastname:"bla"});equal(true,c.is(":visible"));equal(true,$("label.error[for=lastname]").is(":visible"))});test("showErrors(), allow empty string and null as default message",function(){$("#userForm").validate({rules:{username:{required:true,minlength:3}},messages:{username:{required:"",minlength:"too short"}}});ok(!$("#username").valid());equal("",$("label.error[for=username]").text());$("#username").val("ab");ok(!$("#username").valid());equal("too short",$("label.error[for=username]").text());$("#username").val("abc");ok($("#username").valid());ok($("label.error[for=username]").is(":hidden"))});test("showErrors() - external messages",function(){expect(4);var b=$.extend({},$.validator.methods);var d=$.extend({},$.validator.messages);$.validator.addMethod("foo",function(){return false});$.validator.addMethod("bar",function(){return false});equal(0,$("#testForm4 label.error[for=f1]").size());equal(0,$("#testForm4 label.error[for=f2]").size());var c=$("#testForm4")[0];var a=$(c).validate({messages:{f1:"Please!",f2:"Wohoo!"}});a.form();equal($("#testForm4 label.error[for=f1]").text(),"Please!");equal($("#testForm4 label.error[for=f2]").text(),"Wohoo!");$.validator.methods=b;$.validator.messages=d});test("showErrors() - custom handler",function(){expect(5);var a=$("#testForm1").validate({showErrors:function(b,c){equal(a,this);equal(a.errorList,c);equal(a.errorMap,b);equal("buga",b.firstname);equal("buga",b.lastname)}});a.form()});test("option: (un)highlight, default",function(){$("#testForm1").validate();var a=$("#firstname");ok(!a.hasClass("error"));ok(!a.hasClass("valid"));a.valid();ok(a.hasClass("error"));ok(!a.hasClass("valid"));a.val("hithere").valid();ok(!a.hasClass("error"));ok(a.hasClass("valid"))});test("option: (un)highlight, nothing",function(){expect(3);$("#testForm1").validate({highlight:false,unhighlight:false});var a=$("#firstname");ok(!a.hasClass("error"));a.valid();ok(!a.hasClass("error"));a.valid();ok(!a.hasClass("error"))});test("option: (un)highlight, custom",function(){expect(5);$("#testForm1clean").validate({highlight:function(c,b){equal("invalid",b);$(c).hide()},unhighlight:function(c,b){equal("invalid",b);$(c).show()},errorClass:"invalid",rules:{firstname:"required"}});var a=$("#firstnamec");ok(a.is(":visible"));a.valid();ok(!a.is(":visible"));a.val("hithere").valid();ok(a.is(":visible"))});test("option: (un)highlight, custom2",function(){expect(6);$("#testForm1").validate({highlight:function(d,c){$(d).addClass(c);$(d.form).find("label[for="+d.id+"]").addClass(c)},unhighlight:function(d,c){$(d).removeClass(c);$(d.form).find("label[for="+d.id+"]").removeClass(c)},errorClass:"invalid"});var b=$("#firstname");var a=$("#errorFirstname");ok(!b.is(".invalid"));ok(!a.is(".invalid"));b.valid();ok(b.is(".invalid"));ok(a.is(".invalid"));b.val("hithere").valid();ok(!b.is(".invalid"));ok(!a.is(".invalid"))});test("option: focusCleanup default false",function(){var a=$("#userForm");a.validate();a.valid();ok(a.is(":has(label.error[for=username]:visible)"));$("#username").focus();ok(a.is(":has(label.error[for=username]:visible)"))});test("option: focusCleanup true",function(){var a=$("#userForm");a.validate({focusCleanup:true});a.valid();ok(a.is(":has(label.error[for=username]:visible)"));$("#username").focus().trigger("focusin");ok(!a.is(":has(label.error[for=username]:visible)"))});test("option: focusCleanup with wrapper",function(){var a=$("#userForm");a.validate({focusCleanup:true,wrapper:"span"});a.valid();ok(a.is(":has(span:visible:has(label.error[for=username]))"));$("#username").focus().trigger("focusin");ok(!a.is(":has(span:visible:has(label.error[for=username]))"))});test("option: errorClass with multiple classes",function(){var a=$("#userForm");a.validate({focusCleanup:true,wrapper:"span",errorClass:"error error1"});a.valid();ok(a.is(":has(span:visible:has(label.error[for=username]))"));ok(a.is(":has(span:visible:has(label.error1[for=username]))"));$("#username").focus().trigger("focusin");ok(!a.is(":has(span:visible:has(label.error[for=username]))"));ok(!a.is(":has(span:visible:has(label.error1[for=username]))"))});test("elements() order",function(){var a=$("#orderContainer");var b=$("#elementsOrder").validate({errorLabelContainer:a,wrap:"li"});deepEqual(b.elements().map(function(){return $(this).attr("id")}).get(),["order1","order2","order3","order4","order5","order6"],"elements must be in document order");b.form();deepEqual(a.children().map(function(){return $(this).attr("for")}).get(),["order1","order2","order3","order4","order5","order6"],"labels in error container must be in document order")});test("defaultMessage(), empty title is ignored",function(){var a=$("#userForm").validate();equal("This field is required.",a.defaultMessage($("#username")[0],"required"))});test("formatAndAdd",function(){expect(4);var b=$("#form").validate();var a={form:$("#form")[0],name:"bar"};b.formatAndAdd(a,{method:"maxlength",parameters:2});equal("Please enter no more than 2 characters.",b.errorList[0].message);equal("bar",b.errorList[0].element.name);b.formatAndAdd(a,{method:"range",parameters:[2,4]});equal("Please enter a value between 2 and 4.",b.errorList[1].message);b.formatAndAdd(a,{method:"range",parameters:[0,4]});equal("Please enter a value between 0 and 4.",b.errorList[2].message)});test("formatAndAdd2",function(){expect(3);var b=$("#form").validate();var a={form:$("#form")[0],name:"bar"};jQuery.validator.messages.test1=function(d,c){equal(b,this);equal(0,d);return"element "+c.name+" is not valid"};b.formatAndAdd(a,{method:"test1",parameters:0});equal("element bar is not valid",b.errorList[0].message)});test("formatAndAdd, auto detect substitution string",function(){var a=$("#testForm1clean").validate({rules:{firstname:{required:true,rangelength:[5,10]}},messages:{firstname:{rangelength:"at least ${0}, up to {1}"}}});$("#firstnamec").val("abc");a.form();equal("at least 5, up to 10",a.errorList[0].message)});test("error containers, simple",function(){expect(14);var a=$("#simplecontainer");var b=$("#form").validate({errorLabelContainer:a,showErrors:function(){a.find("h3").html(jQuery.validator.format("There are {0} errors in your form.",this.size()));this.defaultShowErrors()}});b.prepareForm();ok(b.valid(),"form is valid");equal(0,a.find("label").length,"There should be no error labels");equal("",a.find("h3").html());b.prepareForm();b.errorList=[{message:"bar",element:{name:"foo"}},{message:"necessary",element:{name:"required"}}];ok(!b.valid(),"form is not valid after adding errors manually");b.showErrors();equal(a.find("label").length,2,"There should be two error labels");ok(a.is(":visible"),"Check that the container is visible");a.find("label").each(function(){ok($(this).is(":visible"),"Check that each label is visible")});equal("There are 2 errors in your form.",a.find("h3").html());b.prepareForm();ok(b.valid(),"form is valid after a reset");b.showErrors();equal(a.find("label").length,2,"There should still be two error labels");ok(a.is(":hidden"),"Check that the container is hidden");a.find("label").each(function(){ok($(this).is(":hidden"),"Check that each label is hidden")})});test("error containers, with labelcontainer I",function(){expect(16);var b=$("#container"),a=$("#labelcontainer");var c=$("#form").validate({errorContainer:b,errorLabelContainer:a,wrapper:"li"});ok(c.valid(),"form is valid");equal(0,b.find("label").length,"There should be no error labels in the container");equal(0,a.find("label").length,"There should be no error labels in the labelcontainer");equal(0,a.find("li").length,"There should be no lis labels in the labelcontainer");c.errorList=[{message:"bar",element:{name:"foo"}},{name:"required",message:"necessary",element:{name:"required"}}];ok(!c.valid(),"form is not valid after adding errors manually");c.showErrors();equal(0,b.find("label").length,"There should be no error label in the container");equal(2,a.find("label").length,"There should be two error labels in the labelcontainer");equal(2,a.find("li").length,"There should be two error lis in the labelcontainer");ok(b.is(":visible"),"Check that the container is visible");ok(a.is(":visible"),"Check that the labelcontainer is visible");var d=a.find("label").each(function(){ok($(this).is(":visible"),"Check that each label is visible1");equal("li",$(this).parent()[0].tagName.toLowerCase(),"Check that each label is wrapped in an li");ok($(this).parent("li").is(":visible"),"Check that each parent li is visible")})});test("errorcontainer, show/hide only on submit",function(){expect(14);var b=$("#container");var a=$("#labelcontainer");var c=$("#testForm1").bind("invalid-form.validate",function(){ok(true,"invalid-form event triggered called")}).validate({errorContainer:b,errorLabelContainer:a,showErrors:function(){b.html(jQuery.validator.format("There are {0} errors in your form.",this.numberOfInvalids()));ok(true,"showErrors called");this.defaultShowErrors()}});equal("",b.html(),"must be empty");equal("",a.html(),"must be empty");ok(!c.form(),"invalid form");equal(2,a.find("label").length);equal("There are 2 errors in your form.",b.html());ok(a.is(":visible"),"must be visible");ok(b.is(":visible"),"must be visible");$("#firstname").val("hix").keyup();$("#testForm1").triggerHandler("keyup",[jQuery.event.fix({type:"keyup",target:$("#firstname")[0]})]);equal(1,a.find("label:visible").length);equal("There are 1 errors in your form.",b.html());$("#lastname").val("abc");ok(c.form(),"Form now valid, trigger showErrors but not invalid-form")});test("option invalidHandler",function(){expect(1);var a=$("#testForm1clean").validate({invalidHandler:function(){ok(true,"invalid-form event triggered called");start()}});$("#usernamec").val("asdf").rules("add",{required:true,minlength:5});stop();$("#testForm1clean").submit()});test("findByName()",function(){deepEqual(new $.validator({},document.getElementById("form")).findByName(document.getElementById("radio1").name).get(),$("#form").find("[name=radio1]").get())});test("focusInvalid()",function(){var a=$("#testForm1 input").focus(function(){equal(a[0],this,"focused first element")});var b=$("#testForm1").validate();b.form();b.focusInvalid()});test("findLastActive()",function(){expect(3);var a=$("#testForm1").validate();ok(!a.findLastActive());a.form();a.focusInvalid();equal(a.findLastActive(),$("#firstname")[0]);var b=$("#lastname").trigger("focus").trigger("focusin")[0];equal(a.lastActive,b)});test("validating multiple checkboxes with 'required'",function(){expect(3);var b=$("#form input[name=check3]").prop("checked",false);equal(b.size(),5);var a=$("#form").validate({rules:{check3:"required"}});a.form();equal(a.size(),1);b.filter(":last").prop("checked",true);a.form();equal(a.size(),0)});test("dynamic form",function(){var a=0;function c(){$("<input data-rule-required='true' name='list"+a+++"' />").appendTo("#testForm2")}function d(f,e){equal(f,b.size(),e)}var b=$("#testForm2").validate();b.form();d(1);c();b.form();d(2);c();b.form();d(3);$("#testForm2 input[name=list1]").remove();b.form();d(2);c();b.form();d(3);$("#testForm2 input[name^=list]").remove();b.form();d(1);$("#agb").attr("disabled",true);b.form();d(0);$("#agb").attr("disabled",false);b.form();d(1)});test("idOrName()",function(){expect(4);var a=$("#testForm1").validate();equal("form8input",a.idOrName($("#form8input")[0]));equal("check",a.idOrName($("#form6check1")[0]));equal("agree",a.idOrName($("#agb")[0]));equal("button",a.idOrName($("#form :button")[0]))});test("resetForm()",function(){function b(d,c){equal(d,a.size(),c)}var a=$("#testForm1").validate();a.form();b(2);$("#firstname").val("hiy");a.resetForm();b(0);equal("",$("#firstname").val(),"form plugin is included, therefor resetForm must also reset inputs, not only errors")});test("message from title",function(){var a=$("#withTitle").validate();a.checkForm();equal(a.errorList[0].message,"fromtitle","title not used")});test("ignoreTitle",function(){var a=$("#withTitle").validate({ignoreTitle:true});a.checkForm();equal(a.errorList[0].message,$.validator.messages.required,"title used when it should have been ignored")});test("ajaxSubmit",function(){expect(1);stop();$("#user").val("Peter");$("#password").val("foobar");jQuery("#signupForm").validate({submitHandler:function(a){jQuery(a).ajaxSubmit({success:function(b){equal("Hi Peter, welcome back.",b);start()}})}});jQuery("#signupForm").triggerHandler("submit")});test("validating groups settings parameter",function(){var a=$("<form>");var b=a.validate({groups:{arrayGroup:["input one","input-two","input three"],stringGroup:"input-four input-five input-six"}});equal(b.groups["input one"],"arrayGroup");equal(b.groups["input-two"],"arrayGroup");equal(b.groups["input three"],"arrayGroup");equal(b.groups["input-four"],"stringGroup");equal(b.groups["input-five"],"stringGroup");equal(b.groups["input-six"],"stringGroup")});test("bypassing validation on form submission",function(){var e=$("#bypassValidation");var c=$("form#bypassValidation :input[id=normalSubmit]");var d=$("form#bypassValidation :input[id=bypassSubmitWithCancel]");var b=$("form#bypassValidation :input[id=bypassSubmitWithNoValidate1]");var a=$("form#bypassValidation :input[id=bypassSubmitWithNoValidate2]");var f=e.validate({debug:true});d.click();equal(f.numberOfInvalids(),0,"Validation was bypassed using CSS 'cancel' class.");f.resetForm();b.click();equal(f.numberOfInvalids(),0,"Validation was bypassed using blank 'formnovalidate' attribute.");f.resetForm();a.click();equal(f.numberOfInvalids(),0,"Validation was bypassed using 'formnovalidate=\"formnovalidate\"' attribute.");f.resetForm();c.click();equal(f.numberOfInvalids(),1,"Validation failed correctly")});module("misc");test("success option",function(){expect(7);equal("",$("#firstname").val());var a=$("#testForm1").validate({success:"valid"});var b=$("#testForm1 label");ok(b.is(".error"));ok(!b.is(".valid"));a.form();ok(b.is(".error"));ok(!b.is(".valid"));$("#firstname").val("hi");a.form();ok(b.is(".error"));ok(b.is(".valid"))});test("success option2",function(){expect(5);equal("",$("#firstname").val());var a=$("#testForm1").validate({success:"valid"});var b=$("#testForm1 label");ok(b.is(".error"));ok(!b.is(".valid"));$("#firstname").val("hi");a.form();ok(b.is(".error"));ok(b.is(".valid"))});test("success option3",function(){expect(5);equal("",$("#firstname").val());$("#errorFirstname").remove();var a=$("#testForm1").validate({success:"valid"});equal(0,$("#testForm1 label").size());$("#firstname").val("hi");a.form();var b=$("#testForm1 label");equal(3,b.size());ok(b.eq(0).is(".valid"));ok(!b.eq(1).is(".valid"))});test("successlist",function(){var a=$("#form").validate({success:"xyz"});a.form();equal(0,a.successList.length)});test("success isn't called for optional elements",function(){expect(4);equal("",$("#firstname").removeAttr("data-rule-required").removeAttr("data-rule-minlength").val());$("#something").remove();$("#lastname").remove();$("#errorFirstname").remove();var a=$("#testForm1").validate({success:function(){ok(false,"don't call success for optional elements!")},rules:{firstname:"email"}});equal(0,$("#testForm1 label").size());a.form();equal(0,$("#testForm1 label").size());$("#firstname").valid();equal(0,$("#testForm1 label").size())});test("success callback with element",function(){expect(1);var a=$("#userForm").validate({success:function(b,c){equal(c,$("#username").get(0))}});$("#username").val("hi");a.form()});test("all rules are evaluated even if one returns a dependency-mistmatch",function(){expect(6);equal("",$("#firstname").removeAttr("data-rule-required").removeAttr("data-rule-minlength").val());$("#lastname").remove();$("#errorFirstname").remove();$.validator.addMethod("custom1",function(){ok(true,"custom method must be evaluated");return true},"");var a=$("#testForm1").validate({rules:{firstname:{email:true,custom1:true}}});equal(0,$("#testForm1 label").size());a.form();equal(0,$("#testForm1 label").size());$("#firstname").valid();equal(0,$("#testForm1 label").size());delete $.validator.methods.custom1;delete $.validator.messages.custom1});test("messages",function(){var a=jQuery.validator.messages;equal("Please enter no more than 0 characters.",a.maxlength(0));equal("Please enter at least 1 characters.",a.minlength(1));equal("Please enter a value between 1 and 2 characters long.",a.rangelength([1,2]));equal("Please enter a value less than or equal to 1.",a.max(1));equal("Please enter a value greater than or equal to 0.",a.min(0));equal("Please enter a value between 1 and 2.",a.range([1,2]))});test("jQuery.validator.format",function(){equal("Please enter a value between 0 and 1.",jQuery.validator.format("Please enter a value between {0} and {1}.",0,1));equal("0 is too fast! Enter a value smaller then 0 and at least -15",jQuery.validator.format("{0} is too fast! Enter a value smaller then {0} and at least {1}",0,-15));var a=jQuery.validator.format("{0} is too fast! Enter a value smaller then {0} and at least {1}");equal("0 is too fast! Enter a value smaller then 0 and at least -15",a(0,-15));a=jQuery.validator.format("Please enter a value between {0} and {1}.");equal("Please enter a value between 1 and 2.",a([1,2]));equal($.validator.format("{0}","$0"),"$0")});test("option: ignore",function(){var a=$("#testForm1").validate({ignore:"[name=lastname]"});a.form();equal(1,a.size())});test("option: subformRequired",function(){jQuery.validator.addMethod("billingRequired",function(c,b){if($("#bill_to_co").is(":checked")){return $(b).parents("#subform").length}return !this.optional(b)},"");var a=$("#subformRequired").validate();a.form();equal(1,a.size());$("#bill_to_co").attr("checked",false);a.form();equal(2,a.size());delete $.validator.methods.billingRequired;delete $.validator.messages.billingRequired});module("expressions");test("expression: :blank",function(){var a=$("#lastname")[0];equal(1,$(a).filter(":blank").length);a.value=" ";equal(1,$(a).filter(":blank").length);a.value="   ";equal(1,$(a).filter(":blank").length);a.value=" a ";equal(0,$(a).filter(":blank").length)});test("expression: :filled",function(){var a=$("#lastname")[0];equal(0,$(a).filter(":filled").length);a.value=" ";equal(0,$(a).filter(":filled").length);a.value="   ";equal(0,$(a).filter(":filled").length);a.value=" a ";equal(1,$(a).filter(":filled").length)});test("expression: :unchecked",function(){var a=$("#check2")[0];equal(1,$(a).filter(":unchecked").length);a.checked=true;equal(0,$(a).filter(":unchecked").length);a.checked=false;equal(1,$(a).filter(":unchecked").length)});module("events");test("validate on blur",function(){function f(g,e){equal(a.size(),g,e)}function d(e){equal(a.errors().filter(":visible").size(),e)}function c(e){e.trigger("blur").trigger("focusout")}$("#errorFirstname").hide();var b=$("#firstname");var a=$("#testForm1").validate();$("#something").val("");c(b);f(0,"No value yet, required is skipped on blur");d(0);b.val("h");c(b);f(1,"Required was ignored, but as something was entered, check other rules, minlength isn't met");d(1);b.val("hh");c(b);f(0,"All is fine");d(0);b.val("");a.form();f(3,"Submit checks all rules, both fields invalid");d(3);c(b);f(1,"Blurring the field results in emptying the error list first, then checking the invalid field: its still invalid, don't remove the error");d(3);b.val("h");c(b);f(1,"Entering a single character fulfills required, but not minlength: 2, still invalid");d(3);b.val("hh");c(b);f(0,"Both required and minlength are met, no errors left");d(2)});test("validate on keyup",function(){function d(f,e){equal(f,a.size(),e)}function c(e){e.trigger("keyup")}var b=$("#firstname");var a=$("#testForm1").validate();c(b);d(0,"No value, no errors");b.val("a");c(b);d(0,"Value, but not invalid");b.val("");a.form();d(2,"Both invalid");c(b);d(1,"Only one field validated, still invalid");b.val("hh");c(b);d(0,"Not invalid anymore");b.val("h");c(b);d(1,"Field didn't loose focus, so validate again, invalid");b.val("hh");c(b);d(0,"Valid")});test("validate on not keyup, only blur",function(){function c(e,d){equal(e,a.size(),d)}var b=$("#firstname");var a=$("#testForm1").validate({onkeyup:false});c(0);b.val("a");b.trigger("keyup");b.keyup();c(0);b.trigger("blur").trigger("focusout");c(1)});test("validate on keyup and blur",function(){function c(e,d){equal(e,a.size(),d)}var b=$("#firstname");var a=$("#testForm1").validate();c(0);b.val("a");b.trigger("keyup");c(0);b.trigger("blur").trigger("focusout");c(1)});test("validate email on keyup and blur",function(){function c(e,d){equal(e,a.size(),d)}var b=$("#firstname");var a=$("#testForm1").validate();a.form();c(2);b.val("a");b.trigger("keyup");c(1);b.val("aa");b.trigger("keyup");c(0)});test("validate checkbox on click",function(){function d(f,e){equal(f,a.size(),e)}function b(e){e.click();e.valid()}var c=$("#check2");var a=$("#form").validate({rules:{check2:"required"}});b(c);d(0);b(c);equal(false,a.form());d(1);b(c);d(0);b(c);d(1)});test("validate multiple checkbox on click",function(){function e(g,f){equal(g,a.size(),f)}function b(f){f.click();f.valid()}var d=$("#check1").attr("checked",false);var c=$("#check1b");var a=$("#form").validate({rules:{check:{required:true,minlength:2}}});b(d);b(c);e(0);b(c);equal(false,a.form());e(1);b(c);e(0);b(c);e(1)});test("correct checkbox receives the error",function(){function b(e){e.click();e.valid()}var d=$("#check1").attr("checked",false);var c=$("#check1b").attr("checked",false);var a=$("#form").find("[type=checkbox]").attr("checked",false).end().validate({rules:{check:{required:true,minlength:2}}});equal(false,a.form());b(d);equal(false,a.form());ok(a.errorList[0].element.id===a.currentElements[0].id,"the proper checkbox has the error AND is present in currentElements")});test("validate radio on click",function(){function e(g,f){equal(g,a.size(),f)}function b(f){f.click();f.valid()}var d=$("#radio1");var c=$("#radio1a");var a=$("#form").validate({rules:{radio1:"required"}});e(0);equal(false,a.form());e(1);b(c);e(0);b(d);e(0)});test("validate input with no type attribute, defaulting to text",function(){function c(e,d){equal(e,a.size(),d)}var a=$("#testForm12").validate();var b=$("#testForm12text");c(0);b.valid();c(1);b.val("test");b.trigger("keyup");c(0)});test("ignore hidden elements",function(){var a=$("#userForm");var b=a.validate({rules:{username:"required"}});a.get(0).reset();ok(!b.form(),"form should be initially invalid");$("#userForm [name=username]").hide();ok(b.form(),"hidden elements should be ignored by default")});test("ignore hidden elements at start",function(){var a=$("#userForm");var b=a.validate({rules:{username:"required"}});a.get(0).reset();$("#userForm [name=username]").hide();ok(b.form(),"hidden elements should be ignored by default");$("#userForm [name=username]").show();ok(!b.form(),"form should be invalid when required element is visible")});test("Specify error messages through data attributes",function(){var d=$("#dataMessages");var c=$("#dataMessagesName");var a=d.validate();d.get(0).reset();c.valid();var b=$("#dataMessages label");equal(b.text(),"You must enter a value here","Correct error label")});test("Updates pre-existing label if has error class",function(){var f=$("#updateLabel"),d=$("#updateLabelInput"),e=$("#targetLabel"),c=f.validate(),a=f.find("label").length,b;d.val("");d.valid();b=f.find("label").length;equal(e.text(),d.attr("data-msg-required"));equal(a,b)});test("Min date set by attribute",function(){var d=$("#rangesMinDateInvalid");var c=$("#minDateInvalid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#rangesMinDateInvalid label");equal(b.text(),"Please enter a value greater than or equal to 2012-12-21.","Correct error label")});test("Max date set by attribute",function(){var d=$("#ranges");var c=$("#maxDateInvalid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value less than or equal to 2012-12-21.","Correct error label")});test("Min and Max date set by attributes greater",function(){var d=$("#ranges");var c=$("#rangeDateInvalidGreater");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value less than or equal to 2013-01-21.","Correct error label")});test("Min and Max date set by attributes less",function(){var d=$("#ranges");var c=$("#rangeDateInvalidLess");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value greater than or equal to 2012-11-21.","Correct error label")});test("Min date set by attribute valid",function(){var d=$("#rangeMinDateValid");var c=$("#minDateValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#rangeMinDateValid label");equal(b.text(),"","Correct error label")});test("Max date set by attribute valid",function(){var d=$("#ranges");var c=$("#maxDateValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max date set by attributes valid",function(){var d=$("#ranges");var c=$("#rangeDateValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max strings set by attributes greater",function(){var d=$("#ranges");var c=$("#rangeTextInvalidGreater");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value less than or equal to 200.","Correct error label")});test("Min and Max strings set by attributes less",function(){var d=$("#ranges");var c=$("#rangeTextInvalidLess");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value greater than or equal to 200.","Correct error label")});test("Min and Max strings set by attributes valid",function(){var d=$("#ranges");var c=$("#rangeTextValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max type absent set by attributes greater",function(){var d=$("#ranges");var c=$("#rangeAbsentInvalidGreater");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value less than or equal to 200.","Correct error label")});test("Min and Max type absent set by attributes less",function(){var d=$("#ranges");var c=$("#rangeAbsentInvalidLess");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value greater than or equal to 200.","Correct error label")});test("Min and Max type absent set by attributes valid",function(){var d=$("#ranges");var c=$("#rangeAbsentValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max range set by attributes valid",function(){var d=$("#ranges");var c=$("#rangeRangeValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max number set by attributes valid",function(){var d=$("#ranges");var c=$("#rangeNumberValid");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"","Correct error label")});test("Min and Max number set by attributes greater",function(){var d=$("#ranges");var c=$("#rangeNumberInvalidGreater");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value less than or equal to 200.","Correct error label")});test("Min and Max number set by attributes less",function(){var d=$("#ranges");var c=$("#rangeNumberInvalidLess");var a=d.validate();d.get(0).reset();c.valid();var b=$("#ranges label");equal(b.text(),"Please enter a value greater than or equal to 50.","Correct error label")});