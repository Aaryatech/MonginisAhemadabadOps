jasmine.HtmlReporterHelpers={};jasmine.HtmlReporterHelpers.createDom=function(f,c,b){var e=document.createElement(f);for(var d=2;d<arguments.length;d++){var g=arguments[d];if(typeof g==="string"){e.appendChild(document.createTextNode(g))}else{if(g){e.appendChild(g)}}}for(var a in c){if(a=="className"){e[a]=c[a]}else{e.setAttribute(a,c[a])}}return e};jasmine.HtmlReporterHelpers.getSpecStatus=function(c){var b=c.results();var a=b.passed()?"passed":"failed";if(b.skipped){a="skipped"}return a};jasmine.HtmlReporterHelpers.appendToSummary=function(e,a){var d=this.dom.summary;var c=(typeof e.parentSuite=="undefined")?"suite":"parentSuite";var b=e[c];if(b){if(typeof this.views.suites[b.id]=="undefined"){this.views.suites[b.id]=new jasmine.HtmlReporter.SuiteView(b,this.dom,this.views)}d=this.views.suites[b.id].element}d.appendChild(a)};jasmine.HtmlReporterHelpers.addHelpers=function(b){for(var a in jasmine.HtmlReporterHelpers){b.prototype[a]=jasmine.HtmlReporterHelpers[a]}};jasmine.HtmlReporter=function(a){var j=this;var h=a||window.document;var b;var f={};j.logRunningSpecs=false;j.reportRunnerStarting=function(k){var l=k.specs()||[];if(l.length==0){return}g(k.env.versionString());h.body.appendChild(f.reporter);i();b=new jasmine.HtmlReporter.ReporterView(f);b.addSpecs(l,j.specFilter)};j.reportRunnerResults=function(k){b&&b.complete()};j.reportSuiteResults=function(k){b.suiteComplete(k)};j.reportSpecStarting=function(k){if(j.logRunningSpecs){j.log(">> Jasmine Running "+k.suite.description+" "+k.description+"...")}};j.reportSpecResults=function(k){b.specComplete(k)};j.log=function(){var k=jasmine.getGlobal().console;if(k&&k.log){if(k.log.apply){k.log.apply(k,arguments)}else{k.log(arguments)}}};j.specFilter=function(k){if(!c()){return true}return k.getFullName().indexOf(c())===0};return j;function c(){var l;(function k(){if(l){return}var n=[];var q=jasmine.HtmlReporter.parameters(h);for(var m=0;m<q.length;m++){var o=q[m].split("=");n[decodeURIComponent(o[0])]=decodeURIComponent(o[1])}l=n.spec})();return l}function g(k){f.reporter=j.createDom("div",{id:"HTMLReporter",className:"jasmine_reporter"},f.banner=j.createDom("div",{className:"banner"},j.createDom("span",{className:"title"},"Jasmine "),j.createDom("span",{className:"version"},k)),f.symbolSummary=j.createDom("ul",{className:"symbolSummary"}),f.alert=j.createDom("div",{className:"alert"},j.createDom("span",{className:"exceptions"},j.createDom("label",{className:"label","for":"no_try_catch"},"No try/catch"),j.createDom("input",{id:"no_try_catch",type:"checkbox"}))),f.results=j.createDom("div",{className:"results"},f.summary=j.createDom("div",{className:"summary"}),f.details=j.createDom("div",{id:"details"})))}function d(){return window.location.search.match(/catch=false/)}function e(){var m=jasmine.HtmlReporter.parameters(window.document);var l=false;var k=0;while(!l&&k<m.length){if(m[k].match(/catch=/)){m.splice(k,1);l=true}k++}if(jasmine.CATCH_EXCEPTIONS){m.push("catch=false")}return m.join("&")}function i(){var k=document.getElementById("no_try_catch");if(d()){k.setAttribute("checked",true);jasmine.CATCH_EXCEPTIONS=false}k.onclick=function(){window.location.search=e()}}};jasmine.HtmlReporter.parameters=function(b){var a=b.location.search.substring(1);var c=[];if(a.length>0){c=a.split("&")}return c};jasmine.HtmlReporter.sectionLink=function(a){var b="?";var c=[];if(a){c.push("spec="+encodeURIComponent(a))}if(!jasmine.CATCH_EXCEPTIONS){c.push("catch=false")}if(c.length>0){b+=c.join("&")}return b};jasmine.HtmlReporterHelpers.addHelpers(jasmine.HtmlReporter);jasmine.HtmlReporter.ReporterView=function(e){this.startedAt=new Date();this.runningSpecCount=0;this.completeSpecCount=0;this.passedCount=0;this.failedCount=0;this.skippedCount=0;this.createResultsMenu=function(){this.resultsMenu=this.createDom("span",{className:"resultsMenu bar"},this.summaryMenuItem=this.createDom("a",{className:"summaryMenuItem",href:"#"},"0 specs")," | ",this.detailsMenuItem=this.createDom("a",{className:"detailsMenuItem",href:"#"},"0 failing"));this.summaryMenuItem.onclick=function(){e.reporter.className=e.reporter.className.replace(/ showDetails/g,"")};this.detailsMenuItem.onclick=function(){d()}};this.addSpecs=function(j,h){this.totalSpecCount=j.length;this.views={specs:{},suites:{}};for(var g=0;g<j.length;g++){var f=j[g];this.views.specs[f.id]=new jasmine.HtmlReporter.SpecView(f,e,this.views);if(h(f)){this.runningSpecCount++}}};this.specComplete=function(f){this.completeSpecCount++;if(c(this.views.specs[f.id])){this.views.specs[f.id]=new jasmine.HtmlReporter.SpecView(f,e)}var g=this.views.specs[f.id];switch(g.status()){case"passed":this.passedCount++;break;case"failed":this.failedCount++;break;case"skipped":this.skippedCount++;break}g.refresh();this.refresh()};this.suiteComplete=function(g){var f=this.views.suites[g.id];if(c(f)){return}f.refresh()};this.refresh=function(){if(c(this.resultsMenu)){this.createResultsMenu()}if(c(this.runningAlert)){this.runningAlert=this.createDom("a",{href:jasmine.HtmlReporter.sectionLink(),className:"runningAlert bar"});e.alert.appendChild(this.runningAlert)}this.runningAlert.innerHTML="Running "+this.completeSpecCount+" of "+a(this.totalSpecCount);if(c(this.skippedAlert)){this.skippedAlert=this.createDom("a",{href:jasmine.HtmlReporter.sectionLink(),className:"skippedAlert bar"})}this.skippedAlert.innerHTML="Skipping "+this.skippedCount+" of "+a(this.totalSpecCount)+" - run all";if(this.skippedCount===1&&b(e.alert)){e.alert.appendChild(this.skippedAlert)}if(c(this.passedAlert)){this.passedAlert=this.createDom("span",{href:jasmine.HtmlReporter.sectionLink(),className:"passingAlert bar"})}this.passedAlert.innerHTML="Passing "+a(this.passedCount);if(c(this.failedAlert)){this.failedAlert=this.createDom("span",{href:"?",className:"failingAlert bar"})}this.failedAlert.innerHTML="Failing "+a(this.failedCount);if(this.failedCount===1&&b(e.alert)){e.alert.appendChild(this.failedAlert);e.alert.appendChild(this.resultsMenu)}this.summaryMenuItem.innerHTML=""+a(this.runningSpecCount);this.detailsMenuItem.innerHTML=""+this.failedCount+" failing"};this.complete=function(){e.alert.removeChild(this.runningAlert);this.skippedAlert.innerHTML="Ran "+this.runningSpecCount+" of "+a(this.totalSpecCount)+" - run all";if(this.failedCount===0){e.alert.appendChild(this.createDom("span",{className:"passingAlert bar"},"Passing "+a(this.passedCount)))}else{d()}e.banner.appendChild(this.createDom("span",{className:"duration"},"finished in "+((new Date().getTime()-this.startedAt.getTime())/1000)+"s"))};return this;function d(){if(e.reporter.className.search(/showDetails/)===-1){e.reporter.className+=" showDetails"}}function c(f){return typeof f==="undefined"}function b(f){return !c(f)}function a(f){var g=f+" spec";if(f>1){g+="s"}return g}};jasmine.HtmlReporterHelpers.addHelpers(jasmine.HtmlReporter.ReporterView);jasmine.HtmlReporter.SpecView=function(b,c,a){this.spec=b;this.dom=c;this.views=a;this.symbol=this.createDom("li",{className:"pending"});this.dom.symbolSummary.appendChild(this.symbol);this.summary=this.createDom("div",{className:"specSummary"},this.createDom("a",{className:"description",href:jasmine.HtmlReporter.sectionLink(this.spec.getFullName()),title:this.spec.getFullName()},this.spec.description));this.detail=this.createDom("div",{className:"specDetail"},this.createDom("a",{className:"description",href:"?spec="+encodeURIComponent(this.spec.getFullName()),title:this.spec.getFullName()},this.spec.getFullName()))};jasmine.HtmlReporter.SpecView.prototype.status=function(){return this.getSpecStatus(this.spec)};jasmine.HtmlReporter.SpecView.prototype.refresh=function(){this.symbol.className=this.status();switch(this.status()){case"skipped":break;case"passed":this.appendSummaryToSuiteDiv();break;case"failed":this.appendSummaryToSuiteDiv();this.appendFailureDetail();break}};jasmine.HtmlReporter.SpecView.prototype.appendSummaryToSuiteDiv=function(){this.summary.className+=" "+this.status();this.appendToSummary(this.spec,this.summary)};jasmine.HtmlReporter.SpecView.prototype.appendFailureDetail=function(){this.detail.className+=" "+this.status();var d=this.spec.results().getItems();var c=this.createDom("div",{className:"messages"});for(var b=0;b<d.length;b++){var a=d[b];if(a.type=="log"){c.appendChild(this.createDom("div",{className:"resultMessage log"},a.toString()))}else{if(a.type=="expect"&&a.passed&&!a.passed()){c.appendChild(this.createDom("div",{className:"resultMessage fail"},a.message));if(a.trace.stack){c.appendChild(this.createDom("div",{className:"stackTrace"},a.trace.stack))}}}}if(c.childNodes.length>0){this.detail.appendChild(c);this.dom.details.appendChild(this.detail)}};jasmine.HtmlReporterHelpers.addHelpers(jasmine.HtmlReporter.SpecView);jasmine.HtmlReporter.SuiteView=function(b,c,a){this.suite=b;this.dom=c;this.views=a;this.element=this.createDom("div",{className:"suite"},this.createDom("a",{className:"description",href:jasmine.HtmlReporter.sectionLink(this.suite.getFullName())},this.suite.description));this.appendToSummary(this.suite,this.element)};jasmine.HtmlReporter.SuiteView.prototype.status=function(){return this.getSpecStatus(this.suite)};jasmine.HtmlReporter.SuiteView.prototype.refresh=function(){this.element.className+=" "+this.status()};jasmine.HtmlReporterHelpers.addHelpers(jasmine.HtmlReporter.SuiteView);jasmine.TrivialReporter=function(a){this.document=a||document;this.suiteDivs={};this.logRunningSpecs=false};jasmine.TrivialReporter.prototype.createDom=function(f,c,b){var e=document.createElement(f);for(var d=2;d<arguments.length;d++){var g=arguments[d];if(typeof g==="string"){e.appendChild(document.createTextNode(g))}else{if(g){e.appendChild(g)}}}for(var a in c){if(a=="className"){e[a]=c[a]}else{e.setAttribute(a,c[a])}}return e};jasmine.TrivialReporter.prototype.reportRunnerStarting=function(h){var c,e;this.outerDiv=this.createDom("div",{id:"TrivialReporter",className:"jasmine_reporter"},this.createDom("div",{className:"banner"},this.createDom("div",{className:"logo"},this.createDom("span",{className:"title"},"Jasmine"),this.createDom("span",{className:"version"},h.env.versionString())),this.createDom("div",{className:"options"},"Show ",c=this.createDom("input",{id:"__jasmine_TrivialReporter_showPassed__",type:"checkbox"}),this.createDom("label",{"for":"__jasmine_TrivialReporter_showPassed__"}," passed "),e=this.createDom("input",{id:"__jasmine_TrivialReporter_showSkipped__",type:"checkbox"}),this.createDom("label",{"for":"__jasmine_TrivialReporter_showSkipped__"}," skipped"))),this.runnerDiv=this.createDom("div",{className:"runner running"},this.createDom("a",{className:"run_spec",href:"?"},"run all"),this.runnerMessageSpan=this.createDom("span",{},"Running..."),this.finishedAtSpan=this.createDom("span",{className:"finished-at"},"")));this.document.body.appendChild(this.outerDiv);var f=h.suites();for(var b=0;b<f.length;b++){var d=f[b];var g=this.createDom("div",{className:"suite"},this.createDom("a",{className:"run_spec",href:"?spec="+encodeURIComponent(d.getFullName())},"run"),this.createDom("a",{className:"description",href:"?spec="+encodeURIComponent(d.getFullName())},d.description));this.suiteDivs[d.id]=g;var a=this.outerDiv;if(d.parentSuite){a=this.suiteDivs[d.parentSuite.id]}a.appendChild(g)}this.startedAt=new Date();var j=this;c.onclick=function(i){if(c.checked){j.outerDiv.className+=" show-passed"}else{j.outerDiv.className=j.outerDiv.className.replace(/ show-passed/,"")}};e.onclick=function(i){if(e.checked){j.outerDiv.className+=" show-skipped"}else{j.outerDiv.className=j.outerDiv.className.replace(/ show-skipped/,"")}}};jasmine.TrivialReporter.prototype.reportRunnerResults=function(f){var c=f.results();var d=(c.failedCount>0)?"runner failed":"runner passed";this.runnerDiv.setAttribute("class",d);this.runnerDiv.setAttribute("className",d);var g=f.specs();var a=0;for(var b=0;b<g.length;b++){if(this.specFilter(g[b])){a++}}var e=""+a+" spec"+(a==1?"":"s")+", "+c.failedCount+" failure"+((c.failedCount==1)?"":"s");e+=" in "+((new Date().getTime()-this.startedAt.getTime())/1000)+"s";this.runnerMessageSpan.replaceChild(this.createDom("a",{className:"description",href:"?"},e),this.runnerMessageSpan.firstChild);this.finishedAtSpan.appendChild(document.createTextNode("Finished at "+new Date().toString()))};jasmine.TrivialReporter.prototype.reportSuiteResults=function(c){var b=c.results();var a=b.passed()?"passed":"failed";if(b.totalCount===0){a="skipped"}this.suiteDivs[c.id].className+=" "+a};jasmine.TrivialReporter.prototype.reportSpecStarting=function(a){if(this.logRunningSpecs){this.log(">> Jasmine Running "+a.suite.description+" "+a.description+"...")}};jasmine.TrivialReporter.prototype.reportSpecResults=function(c){var g=c.results();var b=g.passed()?"passed":"failed";if(g.skipped){b="skipped"}var d=this.createDom("div",{className:"spec "+b},this.createDom("a",{className:"run_spec",href:"?spec="+encodeURIComponent(c.getFullName())},"run"),this.createDom("a",{className:"description",href:"?spec="+encodeURIComponent(c.getFullName()),title:c.getFullName()},c.description));var h=g.getItems();var f=this.createDom("div",{className:"messages"});for(var e=0;e<h.length;e++){var a=h[e];if(a.type=="log"){f.appendChild(this.createDom("div",{className:"resultMessage log"},a.toString()))}else{if(a.type=="expect"&&a.passed&&!a.passed()){f.appendChild(this.createDom("div",{className:"resultMessage fail"},a.message));if(a.trace.stack){f.appendChild(this.createDom("div",{className:"stackTrace"},a.trace.stack))}}}}if(f.childNodes.length>0){d.appendChild(f)}this.suiteDivs[c.suite.id].appendChild(d)};jasmine.TrivialReporter.prototype.log=function(){var a=jasmine.getGlobal().console;if(a&&a.log){if(a.log.apply){a.log.apply(a,arguments)}else{a.log(arguments)}}};jasmine.TrivialReporter.prototype.getLocation=function(){return this.document.location};jasmine.TrivialReporter.prototype.specFilter=function(a){var c={};var e=this.getLocation().search.substring(1).split("&");for(var b=0;b<e.length;b++){var d=e[b].split("=");c[decodeURIComponent(d[0])]=decodeURIComponent(d[1])}if(!c.spec){return true}return a.getFullName().indexOf(c.spec)===0};