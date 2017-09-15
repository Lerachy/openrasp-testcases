<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
	<meta charset="UTF-8" />
	<title>008 - 任意文件上传漏洞</title>
</head>
<body>
	<h1>008 - 任意文件上传漏洞（commons io） </h1>
	<p>使用java最常用的文件上传处理库，struts、spring都用这个</p>
<%
String method = request.getMethod();
if ("POST".equals(method)) {
try {
	boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	if (isMultipart) {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List<FileItem> items = upload.parseRequest(request);
		for (FileItem item: items) { 
			String content = new String(item.get());
		%>
			<div>
				<p>file name: <%= item.getName() %></p>
				<div><%= content %></div>
			</div>
		<%}
	}
} catch (Exception e) {
    if (e.getClass().getName().equals("com.fuxi.javaagent.exception.SecurityException")) {
        response.sendError(400, "Request blocked by OpenRasp");
    }else {	
        out.print(e);
    }
}
} else {
%>
	<p>请求方式:</p>
	<pre>curl '<%= request.getRequestURL()%>' -F 'file=@/path/to/a.jsp'</pre>
	<p>目前，官方插件只检查脚本文件上传的情况，比如 aaa.php, bbb.jsp，其他后缀不会拦截</p>
<%}
%>
</body>
</html>
