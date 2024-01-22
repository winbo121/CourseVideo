package egovframework.common.component.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import egovframework.common.component.file.model.FileData;
import egovframework.common.constrant.EnumCodes.FILE_REG_GB;


/** 파일 DB 접근 MAPPER **/
@Mapper
public interface FileMapper {
	/** 파일 등록 **/
	public Integer addFile( FileData input );

	/** 파일 삭제 **/
	public Integer removeFile(  @Param("file_reg_gb") String file_reg_gb
									 ,@Param("tar_info_pk") String tar_info_pk
									 ,@Param("file_seq_list") List<Integer> file_seq_list );

	/** 파일 리스트 조회  **/
	public List<FileData> getFiles( @Param("file_reg_gb") String file_reg_gb
			 							,@Param("tar_info_pk") String tar_info_pk
			 							,@Param("file_seq") Integer file_seq );

	/** 파일의 순번 변경 **/
	public Integer modifyExpoSort( @Param("file_seq") Integer file_seq
										  ,@Param("expo_sort") Integer expo_sort );

	/** 대상 테이블 파일 수량 변경 **/
	public void modifyTableFileCnt( @Param("file_reg_gb") FILE_REG_GB file_reg_gb
											,@Param("tar_info_pk") String tar_info_pk
											,@Param("file_cnt") int file_cnt );

	
	/** 파일 다운로드에 대한 이력 추가 **/
	public void addFileDownloadLog( @Param("down_type") String down_type );

	public Integer removeFiles(@Param("file_reg_gb") String code, 
									@Param("tar_info_pk") List<String> tar_info_pk, 
									@Param("file_seq_list") List<Integer> file_seq_list);
	
	/** 물리 파일 삭제를 위한 삭제 파일 조회 **/
	public FileData getDeleteFile( @Param("file_seq") Integer file_seq );
	
	/** 물리 파일 삭제를 위한 삭제 파일 seq 조회 **/
	public List<Integer> getDeleteFileSeqs( @Param("file_reg_gb") String file_reg_gb
											,@Param("tar_info_pk") String tar_info_pk );

}
