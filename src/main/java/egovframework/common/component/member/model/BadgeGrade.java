package egovframework.common.component.member.model;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;
import lombok.ToString;

/** 학생 사용자의 보상 등급 **/

@Getter
@AllArgsConstructor( access = AccessLevel.PRIVATE )
@Builder
@ToString
public class BadgeGrade {

	/** 보상 등급 **/
	@NonNull
	private Integer badge_grade;

	/** 보상 레벨 **/
	@NonNull
	private Integer badge_level;

	public static BadgeGradeBuilder builder( Integer badge_grade  ) {
		/**
		 * 보상 레벨 연산
		 * 	새싹		1: 1~5
		 *  잎새		2: 6~10
		 *  가지		3: 11~15
		 *  나무		4: 16~20
		 *  작은열매	5: 21~25
		 *  큰열매	6: 26~30
		 **/
		int level = 1;
	    if( badge_grade >= 6 ) {  level = 2; }
	    if( badge_grade >= 11) { level = 3; }
	    if( badge_grade >= 16 ) { level = 4;  }
	    if( badge_grade >= 21 ) { level = 5;  }
	    if( badge_grade >= 26 ) {  level = 6; }

	    return new BadgeGradeBuilder()
						.badge_grade( badge_grade )
						.badge_level( level );
	}


}
