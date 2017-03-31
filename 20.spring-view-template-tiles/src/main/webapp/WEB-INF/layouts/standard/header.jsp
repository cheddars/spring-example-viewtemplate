<%@ page session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h1><a title="Monitor Something" href="<c:url value="/" />"><img src="<c:url value="/resources/logo-header.gif" />" alt="Solbox" /></a></h1>
<div id="nav">
	<ul>
		<li><a href="<c:url value="/openapi/graph/traffic" />">Traffic</a></li>
		<li><a href="<c:url value="/openapi/graph/hitratio" />">Hitratio</a></li>
	</ul>
</div>
