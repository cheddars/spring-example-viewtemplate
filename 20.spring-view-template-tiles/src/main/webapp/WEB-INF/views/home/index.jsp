<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style type="text/css">
</style>

<div id="userArea">
	<form id="inputForm" name="inputForm" action="/search">
		<fieldset>
		<label for="url">URL : </label><input type="text" id="url" name="url" /><br/>
		<label for="">게시물 Selector : </label><input type="text" id="selector" name="selector" /><br/>
		</fieldset>
	</form>
</div>

<div id="original">

</div>

<div id="analyzed" style="float: left;">
	<div id="analyzed-title">
	</div>
	<div id="analyzed-content">
	</div>
</div>


<script type="text/javascript">
$(function(){
	renderHtml2IFrame($("#original"), "<html><body>test</body></html>");
	renderHtml2IFrame($("#analyzed-title"), "<html><body>test2</body></html>");
	renderHtml2IFrame($("#analyzed-content"), "<html><body>test3</body></html>");
});

function renderHtml2IFrame(attachTo, htmlString){
	var iframe = document.createElement("iframe");
	attachTo.append(iframe);
	var doc = iframe.document;
	
	if(iframe.contentDocument)
		doc = iframe.contentDocument;
	else if(iframe.contentWindow)
		doc = iframe.contentWindow.document;
	
	doc.open();
	doc.writeln(htmlString);
	doc.close();	
}
</script>