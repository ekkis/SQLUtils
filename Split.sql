if object_id('Split') is not null
	drop function Split
go

create function Split(@s varchar(max))
returns @ret table (
	i int, s varchar(128)
)
as
	begin
	/*
	**	- Synopsis -
	**	Splits a string delimited by commas, spaces or 
	**	carriage returns, returning a table with its tokens
	**
	**	- Syntax -
	**	@s: String that is to be split on delimiters into a table
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	insert	@ret
	select	i, s
	from	SplitByCharset(dbo.StrClean(@s), ', ' + char(13) + char(10))
	return
	end
go

-- exempli gratia ------------------------------------------------------------

/*
	select * from dbo.Split('this,that')
	select * from dbo.Split('this that')
	select * from dbo.Split('this
that')
	select * from dbo.Split('this


that')
*/
