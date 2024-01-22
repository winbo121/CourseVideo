package egovframework.common.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ThreadLocalRandom;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collector;
import java.util.stream.Stream;
import org.apache.commons.collections4.ListUtils;
import org.apache.commons.lang3.BooleanUtils;
import org.apache.commons.lang3.ObjectUtils;
import org.springframework.util.AntPathMatcher;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;

import egovframework.common.util.stream.colletor.ImmutableListCollector;
import egovframework.common.util.stream.colletor.ImmutableSetCollector;
import egovframework.common.util.stream.fork.StreamForker;
import lombok.AccessLevel;
import lombok.NoArgsConstructor;

@NoArgsConstructor( access = AccessLevel.PRIVATE  )
public class StreamUtils {

	/** [Null Safety] Object -> StreamForker **/
	public static <T> StreamForker<T> toStreamForker( final T object ) {
		return new StreamForker<T>( toStream(object) );
	}

	/** [Null Safety] Map -> StreamForker **/
	public static <K,V> StreamForker<Map.Entry<K, V>> toStreamForker( final Map<K, V> map ) {
		return new StreamForker<Map.Entry<K, V>>( toStream( map ) );
	}

	/** [Null Safety] Array -> StreamForker **/
	public static <T> StreamForker<T> toStreamForker( final T[] arrays ) {
		return new StreamForker<T>( toStream( arrays ) );
	}

	/** [Null Safety]  Collection -> StreamForker **/
	public static <T> StreamForker<T> toStreamForker( final Collection<T> collection) {
		return new StreamForker<T>( toStream( collection ) );
	}


	/** [Null Safety] Object -> Stream.Builder **/
	public static <T> Stream.Builder<T> toStreamBuilder( final T type ){
		return Optional.ofNullable( type )
					.map( t -> Stream.<T>builder().add( t ) )
					.orElseGet( () -> Stream.<T>builder() );
	}


	/** [Null Safety] Object -> Stream **/
	public static <T> Stream<T> toStream( final T object ) {
		return  toStreamBuilder( object )
					.build();

	}

	/** [Null Safety] Map -> Stream **/
	public static <K,V> Stream<Map.Entry<K, V>> toStream( final Map<K, V> map ) {
		return Optional.ofNullable( map )
	    					.map( Map::entrySet )
	    					.map( Collection::stream  )
	    					.orElseGet( Stream::empty );
	}

	/** [Null Safety] Array -> Stream **/
	public static <T> Stream<T> toStream( final T[] arrays ) {
		return Optional.ofNullable( arrays )
							.map( Arrays::stream )
							.orElseGet( Stream::empty );
	}

	/** [Null Safety]  Collection -> Stream **/
	public static <T> Stream<T> toStream( final Collection<T> collection) {
	    return Optional.ofNullable( collection )
	    					.map( Collection::stream )
	    					.orElseGet( Stream::empty );
	}

	/** [Null Safety] Map -> ParallelStream **/
	public static <K,V> Stream<Map.Entry<K, V>> toParallelStream( final Map<K, V> map ) {
		return Optional.ofNullable( map )
	    					.map( Map::entrySet )
	    					.map( Collection::parallelStream  )
	    					.orElseGet( Stream::empty );
	}

	/** [Null Safety] Array -> ParallelStream **/
	public static <T> Stream<T> toParallelStream( final T[] arrays ) {
		return Optional.ofNullable( arrays )
							.map( Arrays::stream )
							.map( Stream::parallel )
							.orElseGet( Stream::empty );
	}

	/** [Null Safety]  Collection -> ParallelStream **/
	public static <T> Stream<T> toParallelStream( final Collection<T> collection) {
	    return Optional.ofNullable( collection )
							.map( Collection::parallelStream )
							.orElseGet( Stream::empty );
	}

	/** [Comparator] Function 으로 SORTING **/
	public static <T, U extends Comparable<? super U>> Comparator<T> sorting( final Function<? super T, ? extends U> keyExtractor
																									 ,final Boolean isDesc ){
		Objects.requireNonNull( keyExtractor );
		final Comparator<T> comparator = (c1, c2) -> ObjectUtils.compare( keyExtractor.apply(c1) , keyExtractor.apply(c2) );

		if( BooleanUtils.isTrue( isDesc ) ) {
			return comparator.reversed();
		}else {
			return comparator;
		}
	}

	/** [Collector] RANDOM **/
	public static <T> Collector<T, List<T>, Optional<T>> toRandom() {
		final ThreadLocalRandom random = ThreadLocalRandom.current();
	    return Collector.of(	  ArrayList::new
	    						 , List::add
	    						 , ( list1, list2 ) -> ListUtils.union( list1, list2 )
	    						 , ( list ) -> list.isEmpty() ? Optional.empty()
	                            	  				  	   	  : Optional.ofNullable(  list.get( random.nextInt( list.size()) )  )
	                          );
	}

	/** [Collector] GUAVA IMMUTABLE LIST **/
	public static <T> Collector<T, ImmutableList.Builder<T>, ImmutableList<T>> toImmutableList(){
		return ImmutableListCollector.toImmutableList();
	}

	/** [Collector] GUAVA IMMUTABLE SET **/
	public static <T> Collector<T, ImmutableSet.Builder<T>, ImmutableSet<T>> toImmutableSet(){
		return ImmutableSetCollector.toImmutableSet();
	}

	/** [Predicate] KEY 값으로 DISTINCT **/
	public static <T> Predicate<T> distinctByKey( final Function<? super T, ?> keyExtractor ) {
		Objects.requireNonNull( keyExtractor );
		final Map<Object, Boolean> seen = new ConcurrentHashMap<>();
		return t -> seen.putIfAbsent( keyExtractor.apply(t), Boolean.TRUE ) == null;
	}

	/** URI 가 매치 되는지 확인한다.  **/
	public static Predicate<String> isMatchUri ( final String... target_patterns  ){
		final AntPathMatcher mather = new AntPathMatcher();
		return uri -> StreamUtils.toStream( target_patterns  )
										.filter( pattern -> mather.match( pattern,  uri ) )
										.findFirst()
										.isPresent();
	}


}
