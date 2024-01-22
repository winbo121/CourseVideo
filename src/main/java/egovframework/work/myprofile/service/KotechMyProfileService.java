package egovframework.work.myprofile.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import egovframework.common.base.BaseService;
import egovframework.common.component.file.FileComponent;
import egovframework.common.component.file.model.FileData;
import egovframework.common.component.member.MemberComponent;
import egovframework.common.component.member.model.MemberDetail;
import egovframework.common.component.member.model.TsUserInfo;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;
import egovframework.common.error.exception.ErrorMessageException;
import egovframework.common.util.LocalThread;

@Service
public class KotechMyProfileService extends BaseService {
	
	@Autowired
	private MemberComponent memberComponent;
	
	@Autowired
	private FileComponent fileComponent;

	/** 직업 분류 코드 **/
	public List<Map<String, Object>> getJobCode(){
		return memberComponent.getJobCode();
	}
		
	/** 인적사항 상세정보 **/
	public MemberDetail getUserInfo() {
		/** 사용자 상세 정보 **/
		String user_id = LocalThread.getLoginId();
		MemberDetail detail = memberComponent.getMember( user_id )
										.orElseThrow( () -> new ErrorMessageException("com.none.data", "회원정보") );
		
		return detail;

	}
	
	/** 회원 정보 수정 **/
	public boolean updateUserInfo(MemberDetail userInfo) {
		boolean result = false;
		int cnt = 0 ;
		
		/** TS_USER_INFO update **/
		String user_id = LocalThread.getLoginId();
		String gender = userInfo.getGender();
		String user_pw = userInfo.getUser_pw();
		String zip_code = userInfo.getZip_code();
		String user_addr = userInfo.getUser_addr();
		String user_dtl_addr = userInfo.getUser_dtl_addr();
		String sigungu_code = userInfo.getSigungu_code();
		String sido_code = userInfo.getSido_code();
		String age = userInfo.getAge();
		String phone = userInfo.getPhone();
		String job_code = userInfo.getJob_code();
		
		if( StringUtils.isNotEmpty( user_pw ) ) {
			/** 비밀번호 변경 **/
			TsUserInfo ts_user_info = TsUserInfo.builder( user_id )
					.user_pw( memberComponent.encodePassword( user_pw ) )
					.build();
			cnt = memberComponent.modifyTsUserInfo(ts_user_info);
		}
		
		if( StringUtils.isEmpty( user_pw ) ) {
			/** 회원정보 변경 **/
			TsUserInfo ts_user_info = TsUserInfo.builder( user_id )
					.gender( gender )
					.zip_code( zip_code )
					.user_addr( user_addr )
					.user_dtl_addr( user_dtl_addr )
					.sigungu_code( sigungu_code )
					.sido_code( sido_code )
					.age( age )
					.job_code( job_code )
					.phone( phone )
					.build();
			cnt = memberComponent.modifyTsUserInfo(ts_user_info);
		}
		
		
		if(cnt > 0) {
			if(userInfo.getDel_files_seqs() != null && userInfo.getDel_files_seqs().size() > 0) {
				// 첨부파일(섬네일) 삭제
				removeFileupload(userInfo);	
			}
			
			// 첨부파일(섬네일) 등록
			result = addFileupload(userInfo);
			
			result = true;
		}
		
		return result;
	}
	
	/** 회원 탈퇴 **/
	public boolean deleteUser() {
		boolean result = false;
		int cnt = 0;
		String user_id = LocalThread.getLoginId();
		
		
		/** 사용자 정보 삭제  **/
		cnt = memberComponent.removeTsUserInfo( user_id) ;
		if (cnt > 0) {
			/** 프로필 이미지 삭제 **/
			List<FileData> list = fileComponent.getFiles(FILE_REG_GB.TS_USER_INFO  , user_id);
			List<Integer> seqs = new ArrayList<Integer>();
			for(FileData data : list) {
				seqs.add(data.getFile_seq());
			}
			fileComponent.removeFile( FILE_REG_GB.TS_USER_INFO  , user_id );
			fileComponent.deleteRealFiles(seqs);
			
			result = true;
		}
		
		return result;
		
	}
	
	/** 파일 리스트 조회 **/
	public  List<FileData> getFilesThumbnail( ) {
		return fileComponent.getFiles(FILE_REG_GB.TS_USER_INFO, LocalThread.getLoginId());
	}

	
	
	/** 파일 등록  **/
	@Transactional
	public boolean addFileupload( MemberDetail userInfo ) {
		boolean result = false;
		MultipartFile[] upload_files = userInfo.getUpload_files();

		try {
			/** 글등록시에 아래와 같이 파일업로드 **/
			fileComponent.addFiles(FILE_REG_GB.TS_USER_INFO, LocalThread.getLoginId(), Arrays.asList( upload_files ) );
			result = true;
		} catch (Exception e) {
			e.printStackTrace();
			result = false;
		}
			
		return result;

	}
	
	
	/** 파일 삭제  **/
	@Transactional
	public void removeFileupload( MemberDetail userInfo ) {
		List<Integer> file_seq_list = userInfo.getDel_files_seqs();
		fileComponent.removeFile( FILE_REG_GB.TS_USER_INFO, LocalThread.getLoginId(), file_seq_list );
		fileComponent.deleteRealFiles(file_seq_list);
	}



}
