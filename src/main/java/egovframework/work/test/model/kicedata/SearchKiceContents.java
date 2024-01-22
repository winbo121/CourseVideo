package egovframework.work.test.model.kicedata;

import java.io.Serializable;

import javax.validation.constraints.NotEmpty;

import org.apache.commons.lang3.ObjectUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString(callSuper = true)
public class SearchKiceContents implements Serializable {

	private static final long serialVersionUID = -1922932463841350530L;

	/** 검색 책 제목 **/
	@NotEmpty
	private String search_book_name;
	
	/** 검색 출판사 **/
	//@NotEmpty
	private String search_publisher;
	
	/** 출판사 검색 여부 **/
	@JsonIgnore
	public final boolean getIsPublisher() {
		if( ObjectUtils.isEmpty( this.search_publisher ) ) {
			return false;
		}
		return true;
	}
	

}
