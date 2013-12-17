if object_id('SplitPairs') is not null
	drop function SplitPairs
go

create function SplitPairs(@s varchar(4096))
returns @ret table (
	i int
,	name varchar(128)
,	value varchar(128)
)
as
	/*
	**	- Synopsis -
	**	Splits a comma delimited list of name-value pairs, returning
	**	a table with the values.  the pairs should be separated by
	**	equal signs.
	**
	**	- Syntax -
	**	@s: list of tuples
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	begin
	insert	@ret
	select	i
	,	name = left(s, isnull(nullif(charindex('=', s) - 1, -1), len(s)))
	,	value = substring(s, charindex('=', s) + 1, len(s))
	from	Split(@s)

	update	@ret
	set	name = NULL
	where	name = value

	return
	end
go

-- exempli gratia ------------------------------------------------------------

/*
	select * from SplitPairs('x=this,y=that')
*/

