if object_id('StrClean') is not null
	drop function StrClean
go

create function StrClean(@s varchar(max))
returns varchar(max)
as
	begin
	/*
	**	- Synopsis -
	**	Cleans a string of carriage returns, line feeds,
	**	tabs, and leading and trailing spaces.
	**
	**	- Syntax -
	**	@s: the string to clean
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/
	set @s = replace(@s, char(13), '') -- carriage returns
	set @s = replace(@s, char(10), '') -- line feeds
	set @s = replace(@s, char(9), '') -- tabs
	return ltrim(rtrim(@s))
	end
go

-- exempli gratia ------------------------------------------------------------

/*
	select dbo.StrClean(' this	that ')
*/
