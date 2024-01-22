package egovframework.config.filter;

import java.io.InputStream;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.sitemesh.config.xml.XmlFilterConfigurator;
import org.springframework.core.io.Resource;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor( staticName = "of" )
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

	@NonNull
	private Resource config_resource;

	/**
	 * SITE MESH XML 의 위치를 변경하기 위함.
	 */
	@Override
	public void applyCustomConfiguration( SiteMeshFilterBuilder builder ) {

		try( InputStream stream = this.config_resource.getInputStream()  ){
				DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	            DocumentBuilder documentBuilder = factory.newDocumentBuilder();
	            Document document = documentBuilder.parse(stream);
	            Element element = document.getDocumentElement();

	            new XmlFilterConfigurator( getObjectFactory(), element ).configureFilter(builder);
	 	} catch( Exception e){
    		e.printStackTrace();
    	}
	}


}
