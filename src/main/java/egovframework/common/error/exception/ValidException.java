package egovframework.common.error.exception;

import org.springframework.validation.BindingResult;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@AllArgsConstructor
@NoArgsConstructor
public class ValidException extends RuntimeException {

	private static final long serialVersionUID = 8533185183415060613L;

	private BindingResult bindingResult;


}
