defmodule Q do
	@moduledoc """
	Documentation for Q ( Elixir Quantum module ).
	"""

	require Math

	@doc """
	|0> qubit ... ( 1, 0 )

	## Examples
		iex> Q.q0()
		%Array{array: [1, 0], shape: {2, nil}}
		iex> Q.q0().array
		[ 1, 0 ]
	"""
	def q0(), do: Numexy.new( [ 1, 0 ] )

	@doc """
	|1> qubit ... ( 0, 1 )

	## Examples
		iex> Q.q1()
		%Array{array: [0, 1], shape: {2, nil}}
		iex> Q.q1().array
		[ 0, 1 ]
	"""
	def q1(), do: Numexy.new( [ 0, 1 ] )

	@doc """
	1 / sqrt( 2 )

	## Examples
		iex> Q.n07()
		0.7071067811865475
	"""
	def n07(), do: 1 / Math.sqrt( 2 )

	@doc """
	To bit from number, number list or number matrix.

	## Examples
		iex> Q.to_bit( 0.9999999999999998 )
		1
		iex> Q.to_bit( -0.9999999999999998 )
		-1
		iex> Q.to_bit( 0.0 )
		0
		iex> Q.to_bit( 0.7071067811865475 )
		0.7071067811865475
		iex> Q.to_bit( [ 0, 1 ] )
		[ 0, 1 ]
		iex> Q.to_bit( [ 0.9999999999999998, 0 ] )
		[ 1, 0 ]
		iex> Q.to_bit( [ 0.9999999999999998, 0, -0.9999999999999998, 0 ] )
		[ 1, 0, -1, 0 ]
		iex> Q.to_bit( [ [ 0.9999999999999998, 0 ], [ -0.9999999999999998, 0 ] ] )
		[ [ 1, 0 ], [ -1, 0 ] ]
	"""
	def to_bit(  0.9999999999999998 ), do:  1
	def to_bit( -0.9999999999999998 ), do: -1
	def to_bit(  0.0 ), do: 0
	def to_bit( value ) when is_list( value ) do
		case value |> List.first |> is_list do
			true  -> value |> Enum.map( &( &1 |> Enum.map( fn y -> to_bit( y ) end ) ) )
			false -> value |> Enum.map( &( to_bit( &1 ) ) )
		end
	end
	def to_bit( %Array{ array: list, shape: _ } ), do: list |> to_bit |> Numexy.new
	def to_bit( value ), do: value

	@doc """
	X gate.

	## Examples
		iex> Q.x( Q.q0() )
		Q.q1()
		iex> Q.x( Q.q1() )
		Q.q0()
	"""
	def x( qubit ), do: Numexy.dot( xx(), qubit )
	@doc """
	for X gate 2x2 matrix ... ( ( 0, 1 ), ( 1, 0 ) )
	"""
	def xx(), do: Numexy.new [ [ 0, 1 ], [ 1, 0 ] ]

	@doc """
	Z gate.

	## Examples
		iex> Q.z( Q.q0() )
		Q.q0()
		iex> Q.z( Q.q1() )
		-1 |> Numexy.mul( Q.q1() )
		iex> Q.z( Numexy.new [ 0, 0, 0, 1 ] )
		Q.tensordot( Q.q1(), -1 |> Numexy.mul( Q.q1() ), 0 )
		iex> Q.z( Numexy.new [ 0, 0, 0, 1 ] )
		Numexy.new [ 0, 0, 0, -1 ]
	"""
	def z( %Array{ array: _list, shape: { 2, nil } } = qubit ), do: Numexy.dot( z2x(), qubit )
	def z( %Array{ array: _list, shape: { 4, nil } } = qubit ), do: Numexy.dot( z4x(), qubit )
	@doc """
	for Z gate 2x2 matrix ... ( ( 0, 1 ), ( 1, 0 ) )
	"""
	def z2x() do
		Numexy.new [ 
			[ 1, 0 ], 
			[ 0, -1 ]
		]
	end
	@doc """
	for Z gate 4x4 matrix ... ( ( 1, 0, 0, 0 ), ( 0, 1, 0, 0 ), ( 0, 0, 1, 0 ), ( 0, 0, 0, -1 ) )
	"""
	def z4x() do
		Numexy.new [ 
			[ 1, 0, 0,  0 ], 
			[ 0, 1, 0,  0 ], 
			[ 0, 0, 1,  0 ], 
			[ 0, 0, 0, -1 ], 
		]
	end

	@doc """
	Hadamard gate.

	## Examples
		iex> Q.h( Q.q0() )
		Numexy.add( Q.n07() |> Numexy.mul( Q.q0() ), Q.n07() |> Numexy.mul( Q.q1() ) )
		iex> Q.h( Q.q0() )
		Numexy.new [ Q.n07(),  Q.n07() ]
		iex> Q.h( Q.q1() )
		Numexy.sub( Q.n07() |> Numexy.mul( Q.q0() ), Q.n07() |> Numexy.mul( Q.q1() ) )
		iex> Q.h( Q.q1() )
		Numexy.new [ Q.n07(), -Q.n07() ]
	"""
	def h( qubit ), do: Numexy.mul( hx(), 1 / Math.sqrt( 2 ) ) |> Numexy.dot( qubit ) |> to_bit
	@doc """
	for Hadamard gate matrix ... ( ( 1, 1 ), ( 1, -1 ) )
	"""
	def hx(), do: Numexy.new [ [ 1, 1 ], [ 1, -1 ] ]

	@doc """
	Controlled NOT gate.

	## Examples
		iex> Q.cnot( Q.q0(), Q.q0() )	# |00>
		Numexy.new [ 1, 0, 0, 0 ]
		iex> Q.cnot( Q.q0(), Q.q1() )	# |01>
		Numexy.new [ 0, 1, 0, 0 ]
		iex> Q.cnot( Q.q1(), Q.q0() )	# |11>
		Numexy.new [ 0, 0, 0, 1 ]
		iex> Q.cnot( Q.q1(), Q.q1() )	# |10>
		Numexy.new [ 0, 0, 1, 0 ]
	"""
	def cnot( qubit1, qubit2 ), do: Numexy.dot( cx(), tensordot( qubit1, qubit2, 0 ) )
	@doc """
	for Controlled NOT gate 4x4 matrix ... ( ( 1, 0, 0, 0 ), ( 0, 1, 0, 0 ), ( 0, 0, 0, 1 ), ( 0, 0, 1, 0 ) )
	"""
	def cx() do
		Numexy.new [ 
			[ 1, 0, 0, 0 ], 
			[ 0, 1, 0, 0 ], 
			[ 0, 0, 0, 1 ], 
			[ 0, 0, 1, 0 ], 
		]
	end

	@doc """
	Calculate tensor product.<br>
	TODO: Later, transfer to Numexy github

	## Examples
		iex> Q.tensordot( Q.q0(), Q.q0(), 0 )
		Numexy.new( [ 1, 0, 0, 0 ] )
		iex> Q.tensordot( Q.q0(), Q.q1(), 0 )
		Numexy.new( [ 0, 1, 0, 0 ] )
		iex> Q.tensordot( Q.q1(), Q.q0(), 0 )
		Numexy.new( [ 0, 0, 1, 0 ] )
		iex> Q.tensordot( Q.q1(), Q.q1(), 0 )
		Numexy.new( [ 0, 0, 0, 1 ] )
	"""
	def tensordot( %Array{ array: xm, shape: _xm_shape }, %Array{ array: ym, shape: _ym_shape }, _axes ) do
		xv = List.flatten( xm )
		yv = List.flatten( ym )
		xv
		|> Enum.map( fn x -> yv |> Enum.map( fn y -> x * y end ) end )
		|> List.flatten
		|> Numexy.new
	end
end
