package egovframework.config.redis;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.redis.connection.jedis.JedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.repository.configuration.EnableRedisRepositories;
import org.springframework.data.redis.serializer.StringRedisSerializer;


@Profile({"prod"})
@EnableRedisRepositories
@Configuration
public class RedisConfig {
	
	@Value(value="${spring.redis.host}")
    private String spring_redis_host;
	
	@Value(value="${spring.redis.port}")
    private int spring_redis_port;
	
	@Value(value="${spring.redis.password}")
    private String spring_redis_password;

	@Bean
	public JedisConnectionFactory connectionFactory() {
		JedisConnectionFactory jedisConnectionFactory = new JedisConnectionFactory();
		jedisConnectionFactory.setHostName( this.spring_redis_host );
		jedisConnectionFactory.setPort( this.spring_redis_port );
		jedisConnectionFactory.setPassword( this.spring_redis_password );
		return jedisConnectionFactory;
	}
	
	@Bean
	public RedisTemplate<String, Object> redisTemplate() {
		RedisTemplate<String, Object> redisTemplate = new RedisTemplate<>();
		redisTemplate.setKeySerializer(new StringRedisSerializer());
		redisTemplate.setValueSerializer(new StringRedisSerializer());
		redisTemplate.setConnectionFactory(connectionFactory());		
		return redisTemplate;
	}

}