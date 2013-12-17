if object_id('StrToken') is not null
	drop function StrToken
go

create function StrToken (@s varchar(max), @n int, @dc char(1))
returns varchar(max)
as
	/*
	**	- Synopsis -
	**	Used to extract the nth token from a string segmented
	**	by @dc (delimiting character)
	**
	**	- Marginalia -
	**	Author: Erick Calder <e@arix.com>
	*/

	begin
	return (select s from SplitByString(@s, @dc) where i = @n)
	end
go

-- exempli gratia -------------------------------------------------------------

/*
	select dbo.StrToken('der/herrgott/gibt', 2, '/')
*/
