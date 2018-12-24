defmodule Q do
	@moduledoc """
	Documentation for Q ( Elixir Quantum module ).
	"""

	@doc """
	|0> qubit = ( 1, 0 )

	## Examples
		iex> Q.q0.array
		[ 1, 0 ]
	"""
	def q0, do: Numexy.new( [ 1, 0 ] )

	@doc """
	|1> qubit = ( 0, 1 )

	## Examples
		iex> Q.q1.array
		[ 0, 1 ]
	"""
	def q1, do: Numexy.new( [ 0, 1 ] )

	@doc """
	X gate.

	## Examples
		iex> Q.x( Q.q0 ).array
		[ 0, 1 ]
		iex> Q.x( Q.q1 ).array
		[ 1, 0 ]

		iex> ( Q.z( Q.q1 ) |> Q.x ).array
		[ -1, 0 ]
		iex> ( Q.z( Q.q1 ) |> Q.x |> Q.x ).array
		[ 0, -1 ]

		iex> ( Q.h( Q.q0 ) |> Q.x ).array
		[ 1 / Math.sqrt( 2 ) * 1, 1 / Math.sqrt( 2 ) * 1 ]
		iex> ( Q.h( Q.q1 ) |> Q.x ).array
		[ 1 / Math.sqrt( 2 ) * -1, 1 / Math.sqrt( 2 ) * 1 ]
	"""
	def x( qbit ),  do: Numexy.dot( x_matrix(), qbit )
	def x_matrix(), do: Numexy.new( [ [ 0, 1 ], [ 1, 0 ] ] )

	@doc """
	Z gate.

	## Examples
		iex> Q.z( Q.q0 ).array
		[ 1, 0 ]
		iex> Q.z( Q.q1 ).array
		[ 0, -1 ]

		iex> ( Q.h( Q.q0 ) |> Q.z ).array
		[ 1 / Math.sqrt( 2 ) * 1, 1 / Math.sqrt( 2 ) * -1 ]
		iex> ( Q.h( Q.q1 ) |> Q.z ).array
		[ 1 / Math.sqrt( 2 ) * 1, 1 / Math.sqrt( 2 ) * 1 ]
	"""
	def z( qbit ),  do: Numexy.dot( z_matrix(), qbit )
	def z_matrix(), do: Numexy.new( [ [ 1, 0 ], [ 0, -1 ] ] )

	@doc """
	Hadamard gate.

	## Examples
		iex> Q.h( Q.q0 ).array
		[ 1 / Math.sqrt( 2 ) * 1, 1 / Math.sqrt( 2 ) * 1 ]
		iex> Q.h( Q.q1 ).array
		[ 1 / Math.sqrt( 2 ) * 1, 1 / Math.sqrt( 2 ) * -1 ]

		iex> ( Q.h( Q.q0 ) |> Q.h ).array
		[ 1, 0 ]
		iex> ( Q.h( Q.q1 ) |> Q.h ).array
		[ 0, 1 ]

		iex> ( Numexy.new( [ Q.q0.array, Q.q1.array ] ) |> Q.cut( 0 ) |> Q.h |> Q.x |> Q.h ).array
		[ 1, 0 ]
		iex> ( Numexy.new( [ Q.q0.array, Q.q1.array ] ) |> Q.cut( 1 ) |> Q.h |> Q.x |> Q.h ).array
		[ 0, -1 ]
	"""
	def h( qbit ),  do: Numexy.dot( h_matrix(), qbit ) |> to_bit
	def h_matrix(), do: 1 / Math.sqrt( 2 ) |> Numexy.mul( Numexy.new( [ [ 1, 1 ], [ 1, -1 ] ] ) )
	def to_bit(  0.9999999999999998 ), do:  1
	def to_bit( -0.9999999999999998 ), do: -1
	def to_bit(  0.4999999999999999 ), do:  0.5
	def to_bit( -0.4999999999999999 ), do: -0.5
	def to_bit(  0.0 ), do: 0
	def to_bit( value ) when is_list( value ) do
		case value |> List.first |> is_list do
			true  -> value |> Enum.map( &( &1 |> Enum.map( fn n -> to_bit( n ) end ) ) )
			false -> value |> Enum.map( &( to_bit( &1 ) ) )
		end
	end
	def to_bit( %Array{ array: list, shape: _ } ), do: list |> to_bit |> Numexy.new
	def to_bit( others ), do: others

	@doc """
	Controlled NOT gate.

	## Examples
		iex> Q.cnot( Q.q0, Q.q0 ).array	# |00>
		[ [ 1, 0 ], [ 0, 0 ] ]
		iex> Q.cnot( Q.q0, Q.q1 ).array	# |01>
		[ [ 0, 1 ], [ 0, 0 ] ]
		iex> Q.cnot( Q.q1, Q.q0 ).array	# |11>
		[ [ 0, 0 ], [ 0, 1 ] ]
		iex> Q.cnot( Q.q1, Q.q1 ).array	# |10>
		[ [ 0, 0 ], [ 1, 0 ] ]
	"""
	def cnot( qbit1, qbit2 ), do: ( Numexy.dot( cnot_matrix(), tensordot( qbit1, qbit2 ) ) ).array |> Numexy.reshape( 2 )
	def cnot_matrix() do
		Numexy.new( 
			[ 
				[ 1, 0, 0, 0 ], 
				[ 0, 1, 0, 0 ], 
				[ 0, 0, 0, 1 ], 
				[ 0, 0, 1, 0 ], 
			]
		)
	end
	def tensordot( %Array{ array: xm, shape: _xm_shape }, %Array{ array: ym, shape: _ym_shape } ) do
		xv = List.flatten( xm )
		yv = List.flatten( ym )
		xv
		|> Enum.map( fn x -> yv |> Enum.map( fn y -> x * y end ) end )
		|> List.flatten
		|> Numexy.new
	end

	@doc """
	Y gate.

	## Examples
		iex> Q.y( Q.q0 ).array
		[ 0, ComplexNum.new( 0, 1 ) ]
		iex> Q.y( Q.q1 ).array
		[ ComplexNum.new( 0, -1 ), 0 ]

		iex> ( Q.y( Q.q0 ) |> Q.y ).array
		[ 1, 0 ]
		iex> ( Q.y( Q.q1 ) |> Q.y ).array
		[ 0, 1 ]
	"""
	def y( qbit ),  do: complex_dot( y_matrix(), qbit )
	def y_matrix(), do: Numexy.new( [ [ 0, ComplexNum.new( 0, -1 ) ], [ ComplexNum.new( 0, 1 ), 0 ] ] )
	def complex_dot( %Array{ array: xm, shape: { xm_row, nil } }, %Array{ array: ym, shape: { ym_row, nil } } ) when xm_row == ym_row do
		complex_dot_vector( xm, ym ) |> Numexy.new
	end
	def complex_dot( %Array{ array: xm, shape: { _, xm_col } }, %Array{ array: ym, shape: { ym_row, nil } } ) when xm_col == ym_row do
		( for x <- xm, y <- [ ym ], do: [ x, y ] )
		|> Enum.map( fn [ x, y ] -> complex_dot_vector( x, y ) end )
		|> Numexy.new
	end
	def complex_dot_vector( xm, ym ) do
		result = Enum.zip( xm, ym )
		|> Enum.reduce( 0, fn { a, b }, acc -> complex_mult( a, b ) |> complex_add( acc ) end )
		if result == ComplexNum.new( 0, 0 ), do: 0, else: result
	end
	def complex_mult( a, b ) when is_map( a ) or is_map( b ), do: ComplexNum.mult( a, b )
	def complex_mult( a, b ),                                 do: a * b
	def complex_add(  a, b ) when is_map( a ) or is_map( b ), do: ComplexNum.add(  a, b )
	def complex_add(  a, b ),                                 do: a + b

	@doc """
	Cut qbit.

	## Examples
		iex> Q.cut( Numexy.new( [ Q.q0.array, Q.q1.array ] ), 0 ).array
		[ 1, 0 ]
		iex> Q.cut( Numexy.new( [ Q.q0.array, Q.q1.array ] ), 1 ).array
		[ 0, 1 ]
	"""
	def cut( qbit, no ), do: qbit.array |> Enum.at( no ) |> Numexy.new
end
