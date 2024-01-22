package egovframework.config;

import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.io.DefaultVFS;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import egovframework.common.constrant.Constrants;
import egovframework.config.util.ConfigUtils;

@Configuration
@EnableTransactionManagement
@MapperScan( annotationClass= Mapper.class
			  ,sqlSessionTemplateRef="apiSqlSessionTemplate"
			  ,basePackages={ Constrants.COMMON_PACKAGE, Constrants.BUSINESS_PACKAGE,  Constrants.CONFIG_PACKAGE } )
public class DataBaseConfig {

	@Value(value="${jdbc.driver}") private String jdbc_driver;
	@Value(value="${jdbc.url}") private String jdbc_url;
	@Value(value="${jdbc.username}") private String jdbc_username;
	@Value(value="${jdbc.password}") private String jdbc_password;
	@Value(value="${jdbc.maxactive}") private int jdbc_maxactive;
	@Value(value="${jdbc.jdbc_maxwait}") private int jdbc_maxwait;

	@Bean(name = "apiDataSource" )
	public BasicDataSource apiDataSource() {
		BasicDataSource dataSource = new BasicDataSource();
		dataSource.setDriverClassName( this.jdbc_driver );
		dataSource.setUrl( this.jdbc_url );
		dataSource.setUsername( this.jdbc_username );
		dataSource.setPassword( this.jdbc_password );
		dataSource.setMaxActive( this.jdbc_maxactive );
		dataSource.setMaxWait( this.jdbc_maxwait );
	
		return dataSource;
	}

	@Bean(name = "apiSqlSessionTemplate")
    public SqlSessionTemplate apiSqlSessionTemplateLocal( @Qualifier("apiDataSource") DataSource apiDataSource ) throws Exception {

		/** SESSION FACTORY 생성 **/
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource( apiDataSource );
		sqlSessionFactoryBean.setConfigLocation( ConfigUtils.getResource( Constrants.MYBATIS_CONFIG_LOCATION  ) );
		sqlSessionFactoryBean.setMapperLocations( ConfigUtils.getResources( Constrants.MYBATIS_MAPPER_LOCATIONS ) );
	    sqlSessionFactoryBean.setVfs( DefaultVFS.class );

	    sqlSessionFactoryBean.afterPropertiesSet();
	    return new SqlSessionTemplate( sqlSessionFactoryBean.getObject() );

	}


	/** 트랜잭션 메니저  @Primary 설정으로 기본 트랜잭션메니져로 설정 **/
	@Bean(name = "transactionManager")
	@Primary
	public PlatformTransactionManager transactionManager( @Qualifier("apiDataSource") DataSource apiDataSource ) {
		/** API TRANSACTION MANAGER **/
		DataSourceTransactionManager api_transaction = new DataSourceTransactionManager( apiDataSource );
		return api_transaction;
	}


}
