if object_id('StrQuote') is not null
	drop function StrQuote
go

create function dbo.StrQuote(@s varchar(max))
returns varchar(max)
as
	begin
	/*
	**	- Synopsis -
	**	Quotes a string
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	return	char(39)
	+	replace(@s, char(39), char(39) + char(39))
	+	char(39)
	end
go

-- exempli gratia -------------------------------------------------------------

/*
	select dbo.StrQuote('Rick place')
	,	dbo.StrQuote('Rick''s place')
*/

