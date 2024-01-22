package egovframework.common.valid.validator;


import java.util.Optional;
import java.util.stream.Stream;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.valid.annotation.FileExtension;


/**
 * 파일의 확장자를 체크한다.
 * @author yoon
 * @param <T>
 * @param <T>
 */
public class FileExtensionValidator implements ConstraintValidator<FileExtension, Object > {


	private String[] extensions;


	@Override
	public void initialize( FileExtension constraintAnnotation) {
		this.extensions = constraintAnnotation.extensions();
	}

	@Override
	public boolean isValid( Object value, ConstraintValidatorContext context) {
		if( value == null ) {
			return true;
		}
		if( value instanceof MultipartFile ) {
			/** 단일 파일에 대한 유효성 체크  **/
			MultipartFile file = (MultipartFile) value;
			return this.hasExtension( file );
		}

		/** 파일 배열에 대한 유효성 체크 **/
		if( value instanceof  MultipartFile[] ) {
			MultipartFile[] files = (MultipartFile[]) value;
			if (ArrayUtils.isEmpty( files ) ) {
				return true;
			}

			/** 적합하지 않은 확장자가 있는지 조회한다. **/
			Boolean has_not_match_file = Stream.of( files ).filter( file -> { return !this.hasExtension( file );  } )
																	 .findFirst()
																	 .isPresent();

			if( BooleanUtils.isTrue( has_not_match_file ) ) {
				return false;
			}
		}

		return true;
	}


	/** 구분자 확인  **/
	private boolean hasExtension( MultipartFile multiPartFile ) {
		if( multiPartFile == null ) {
			return false;
		}
		if( multiPartFile.isEmpty() ) {
			return false;
		}
		if( ArrayUtils.isEmpty( this.extensions ) ) {
			return true;
		}

		/** 물리 파일 명 **/
		String file_name = StringUtils.cleanPath( multiPartFile.getOriginalFilename() );
		Optional<String> target_ext = Stream.of( this.extensions )
						.filter( ext -> {
											String suffix = "." + ext ;
											return  StringUtils.endsWithIgnoreCase( file_name, suffix);
										}
						 )
						.findFirst();

		return target_ext.isPresent();
	}




}
