package egovframework.common.util.stream.colletor;

import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collector;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Sets;

/** GUAVA ImmutableList 를 확장 구현함  **/
public final class ImmutableListCollector<T>  implements Collector<T, ImmutableList.Builder<T>, ImmutableList<T>> {

	private ImmutableListCollector() {}

	@Override
	public Supplier<ImmutableList.Builder<T>> supplier() {
		return ImmutableList::builder;
	}

	@Override
	public BiConsumer<ImmutableList.Builder<T>, T> accumulator() {
	    return ImmutableList.Builder::add;
	}

	@Override
	public BinaryOperator<ImmutableList.Builder<T>> combiner() {
	    return (left, right) -> left.addAll(right.build());
	}

	@Override
	public Function<ImmutableList.Builder<T>, ImmutableList<T>> finisher() {
	    return ImmutableList.Builder::build;
	}

	@Override
	public Set<Characteristics> characteristics() {
	    return Sets.immutableEnumSet(Characteristics.UNORDERED);
	}

	public static <T> ImmutableListCollector<T> toImmutableList(){
		return new ImmutableListCollector<T>();
	}

}
