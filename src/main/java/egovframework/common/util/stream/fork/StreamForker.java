package egovframework.common.util.stream.fork;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Spliterator;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Future;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.function.Consumer;
import java.util.function.Function;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

/**
 * Stream 을 forking 하기 위해서 구현
 * java 11 까지 해당 기능이 구현되지 않았음.
 * 병렬 stream 에서는 적합하지 않음.
 * @author yoon
 * @param <T>
 */
public class StreamForker<T> {

	private final Stream<T> stream;
	private final Map<Object, Function<Stream<T>, ? > > forks = new HashMap<>();

	public StreamForker( Stream<T> stream ) {
		this.stream = stream;
	}

	public StreamForker<T> fork( Object key, Function<Stream<T>, ? > f ){
		this.forks.put(key, f);
		return this;
	}

	public ForkerResults getForkerResults() {
		ForkingStreamConsumer<T> consumer = this.build();
		try {
			this.stream.sequential().forEach( consumer );
		} finally {
			consumer.finish();
		}
		return consumer;
	}

	private Future<?> getOperationResult( List<BlockingQueue<T>> queues, Function<Stream<T>, ? > f ){
		BlockingQueue<T> queue = new LinkedBlockingQueue<>();
		queues.add( queue );
		Spliterator<T> spliterator = new BlockingQueueSpliterator( queue );
		Stream<T> source = StreamSupport.stream( spliterator, false );
		return CompletableFuture.supplyAsync( () -> f.apply( source ) );
	}

	private ForkingStreamConsumer<T> build(){
		List<BlockingQueue<T> > queues = new ArrayList<>();

		Map<Object, Future<?>> actions =
		this.forks.entrySet()
					.stream()
					.reduce( new HashMap<Object, Future<?>>()
								,( map, e ) ->{
									Object key = e.getKey();
									Function<Stream<T>, ?> value = e.getValue();
									Future<?>  future = this.getOperationResult(queues,  value );
									map.put(key, future);
									return map;
								}
								,(m1, m2) ->{
									m1.putAll(m2);
									return m1;
								}
							);
		return new ForkingStreamConsumer<>(queues, actions);
	}

	class BlockingQueueSpliterator implements Spliterator<T>{
		private final BlockingQueue<T> q;

		BlockingQueueSpliterator( BlockingQueue<T> q ){
			this.q = q;
		}

		@Override
		public boolean tryAdvance(Consumer<? super T> action) {
			T t;
			while ( true ) {
				try {
					t = this.q.take();
					break;
				} catch ( Exception e) {}
			}
			if( t != ForkingStreamConsumer.END_OF_STREAM ) {
				action.accept( t );
				return true;
			}
			return false;
		}

		@Override
		public Spliterator<T> trySplit() {
			return null;
		}
		@Override
		public long estimateSize() {
			return 0;
		}
		@Override
		public int characteristics() {
			return 0;
		}
	}


	public static interface ForkerResults {
		public <R> R get( Object key );
	}


	static class ForkingStreamConsumer<T> implements Consumer<T> , ForkerResults {
		static final Object END_OF_STREAM = new Object();

		private List<BlockingQueue<T>> queues;
		private final Map<Object, Future<?>> actions;

		ForkingStreamConsumer( List<BlockingQueue<T>> queues, Map<Object, Future<?>> actions ){
			this.queues = queues;
			this.actions = actions;
		}

		@Override
		public void accept( T t ) {
			this.queues.forEach( q -> q.add(t) );
		}

		@SuppressWarnings("unchecked")
		void finish() {
			this.accept( (T) END_OF_STREAM );
		}

		@Override
		@SuppressWarnings("unchecked")
		public <R> R get(Object key) {
			try {
				return (  ( Future<R>) this.actions.get(key) ).get();
			}catch( Exception e) {
				throw new RuntimeException( e );
			}
		}



	}



}
