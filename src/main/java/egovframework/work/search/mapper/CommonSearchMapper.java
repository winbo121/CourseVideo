package egovframework.work.search.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonSearchMapper {

	void insertSearchLog(Map<String, Object> param);

}
