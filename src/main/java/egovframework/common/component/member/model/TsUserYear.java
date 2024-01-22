package egovframework.common.component.member.model;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NonNull;

@Builder
@AllArgsConstructor( access = AccessLevel.PRIVATE )
@Getter
public class TsUserYear {

	@NonNull
	private String year_cd;
	@NonNull
	private String user_id;
	@NonNull
	private String sch_cd;

	private String sch_grade;

	private String sch_class;
	
	private String transfer_yn;

	public static TsUserYearBuilder builder( String year_cd, String user_id, String sch_cd) {
		return new TsUserYearBuilder()
					    .year_cd(year_cd)
					    .user_id(user_id)
					    .sch_cd(sch_cd);
	}


}
