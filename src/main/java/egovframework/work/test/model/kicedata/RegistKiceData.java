package egovframework.work.test.model.kicedata;

import java.io.Serializable;
import javax.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter @Setter
@ToString(callSuper = true)
public class RegistKiceData implements Serializable {

	private static final long serialVersionUID = -5330284340971063317L;

	@NotEmpty
	private String book_seq;	/* 도서목록순번 */

	@NotEmpty
	private String book_keyword;	/* 키워드 */

	@NotEmpty
	private String intro_reason;	/* 책 소개 이유 */

	@NotEmpty
	private String book_recomm_rect;	/* 독서 활동 추천 박스 */

	@NotEmpty
	private String book_recommend;	/* 독서 활동 추천 그 외 */

	@NotEmpty
	private String textbook_link;	/* 교과 연계 방향 */

	@NotEmpty
	private String words_activity;	/* 어휘 학습 */


}
