package org.apache.jsp;

import java.io.IOException;

import javax.servlet.ServletException;

import org.apache.sling.scripting.jsp.jasper.el.ELContextImpl;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockPageContext;
import org.springframework.mock.web.MockServletConfig;
import org.springframework.mock.web.MockServletContext;

public class index_jspTest {

	@Test
	public void test_jspServiceHttpServletRequestHttpServletResponse() throws IOException, ServletException {
		index_jsp jsp = new index_jsp();
		
		ELContextImpl elc = new ELContextImpl();
		MockHttpServletRequest request = new MockHttpServletRequest();
		MockServletContext ctx = (MockServletContext) request.getServletContext();
		
		MockPageContext pctx = new MockPageContext(ctx);
		
		MockServletConfig config = new MockServletConfig();
		jsp.init(config);
		System.out.println("ctx : " + ctx);
		request.setContextPath("/");
		MockHttpServletResponse response = new MockHttpServletResponse();
		
		jsp._jspService(request, response);
		
		System.out.println("response : " + response.getContentAsString());
		
		
	}

}
