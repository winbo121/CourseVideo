package egovframework.work.main.dto;

import lombok.*;






@Getter
@Setter
@Builder
@NoArgsConstructor
public class MemberDto {

	private String id;
    private String nickname;
    private String email;
    private String password;


    @Builder
    public MemberDto(String id, String nickname, String email, String password) {
        this.id = id;
        this.nickname = nickname;
        this.email = email;
        this.password = password;
    }
}