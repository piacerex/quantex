defmodule QPrimitiveTest do
	use PowerAssert

	test "qubits" do
		assert Q.q0().array == [ 1, 0 ]
		assert Q.q1().array == [ 0, 1 ]
		assert Q.n07() == 0.7071067811865475
	end

	test "to_bit Unit" do
		assert  0.9999999999999998 |> Q.to_bit ==  1
		assert -0.9999999999999998 |> Q.to_bit == -1
		assert  0.0 |> Q.to_bit == 0
		assert  0 |> Q.to_bit == 0
	end

	test "to_bit Vector" do
		assert [ 0, 0 ] |> Q.to_bit == [ 0, 0 ]
		assert [ 0.9999999999999998, 0 ] |> Q.to_bit == [ 1, 0 ]
		assert [ 0, 0.9999999999999998 ] |> Q.to_bit == [ 0, 1 ]
		assert [ 0.9999999999999998, 0.9999999999999998 ] |> Q.to_bit == [ 1, 1 ]

		assert [ 0.9999999999999998, 0, -0.9999999999999998, 0 ] |> Q.to_bit == [ 1, 0, -1, 0 ]
		assert [ 1, 0.9999999999999998, 0, -0.9999999999999998 ] |> Q.to_bit == [ 1, 1, 0, -1 ]
	end

	test "to_bit Matrix" do
		assert [ [ 0.9999999999999998, 0 ], [ -0.9999999999999998, 0 ] ] |> Q.to_bit == [ [ 1, 0 ], [ -1, 0 ] ]
		assert [ [ 1, 0 ], [ -1, 0 ] ] |> Q.to_bit == [ [ 1, 0 ], [ -1, 0 ] ]
	end
end

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
end

defmodule QGateTest do
	use PowerAssert

	test "X Gate" do
		assert Q.x( Q.q0() ) == Q.q1()
		assert Q.x( Q.q1() ) == Q.q0()
	end

	test "Z Gate 2x1" do
		assert Q.z( Q.q0() ) == Q.q0()
		assert Q.z( Q.q1() ) == -1 |> Numexy.mul( Q.q1() )
	end

	test "Hadamard Gate" do
		assert Q.h( Q.q0() ) == Numexy.add( Q.n07() |> Numexy.mul( Q.q0() ), Q.n07() |> Numexy.mul( Q.q1() ) )
		assert Q.h( Q.q0() ) == Numexy.new [ Q.n07(),  Q.n07() ]
		assert Q.h( Q.q1() ) == Numexy.sub( Q.n07() |> Numexy.mul( Q.q0() ), Q.n07() |> Numexy.mul( Q.q1() ) )
		assert Q.h( Q.q1() ) == Numexy.new [ Q.n07(), -Q.n07() ]
	end
end
