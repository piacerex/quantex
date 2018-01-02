defmodule NumexyPrimitiveTest do
	use PowerAssert

	test "Inner Product on 2x1", do: assert Numexy.dot( Numexy.new( [ 1,  1 ] ), Numexy.new( [ 1, -1 ] ) ) == 0

	test "Outer Production" do
		assert Numexy.outer( Q.q1(), Q.q0() ) == Numexy.new( [ [ 0, 0 ], [ 1, 0 ] ] )
		assert Numexy.outer( Q.q1(), Q.q0() ).array |> List.flatten |> Numexy.new == Numexy.new( [ 0, 0, 1, 0 ] )
	end

	test "Reshape" do
		assert Numexy.reshape( [ 1, 2, 3, 4, 5, 6 ], 2 ) == Numexy.new( [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ] )
		assert Numexy.reshape( [ 1, 2, 3, 4, 5, 6 ], 3 ) == Numexy.new( [ [ 1, 2, 3 ], [ 4, 5, 6 ] ] )
	end

	test "tensordot" do
		assert Q.tensordot( Q.q0(), Q.q0(), 0 ) == Numexy.outer( Q.q0(), Q.q0() ).array |> List.flatten |> Numexy.new
		assert Q.tensordot( Q.q0(), Q.q0(), 0 ) == Numexy.new( [ 1, 0, 0, 0 ] )

		assert Q.tensordot( Q.q0(), Q.q1(), 0 ) == Numexy.outer( Q.q0(), Q.q1() ).array |> List.flatten |> Numexy.new
		assert Q.tensordot( Q.q0(), Q.q1(), 0 ) == Numexy.new( [ 0, 1, 0, 0 ] )

		assert Q.tensordot( Q.q1(), Q.q0(), 0 ) == Numexy.outer( Q.q1(), Q.q0() ).array |> List.flatten |> Numexy.new
		assert Q.tensordot( Q.q1(), Q.q0(), 0 ) == Numexy.new( [ 0, 0, 1, 0 ] )

		assert Q.tensordot( Q.q1(), Q.q1(), 0 ) == Numexy.outer( Q.q1(), Q.q1() ).array |> List.flatten |> Numexy.new
		assert Q.tensordot( Q.q1(), Q.q1(), 0 ) == Numexy.new( [ 0, 0, 0, 1 ] )
	end
end
