/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.work.oauth.mapper;

import org.apache.ibatis.annotations.Param;

import egovframework.work.oauth.model.OAuthUniversalUser;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


/**
 * 소셜 연동 관련
 *
 * @author  KOTECH
 * @since 2023.03.14
 * @version 1.0
 * @see <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2023.03.14        KOTECH          최초 생성
 *
 * </pre>
 */
@Mapper
public interface OAuthMapper {
	
	/* 소셜 정보 등록 여부 체크 */
	public String checkSocialUser(OAuthUniversalUser oauthUser);
	
	/* 소셜 연동 정도 등록 */
	public int insertSocialUser(@Param("userId")String string, @Param("seNm")String string2, @Param("idntfNo")String string3,@Param("connId") String string4);
	
	/* 소셜 연동 정보 취소(삭제)*/
	public int deleteSocialUser(@Param("userId") String string, @Param("seNm")String string2);
	
	/* 소셜 연동 내역 조회 */
	public List<Map<String, Object>> getSocialInfoList();
	

}
