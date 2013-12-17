if object_id('Seq') is not null
	drop function Seq
go

create function dbo.Seq(@n int)
returns @ret table(i int)
as
	begin
	/*
	**	- Synopsis -
	**	Generates a sequence, starting with 1 and ending
	**	with the argument passed.
	**
	**	- Syntax -
	**	@n = The top of the sequence
	**
	**	- Metadata -
	**	Author: Erick Calder <e@arix.com>
	*/

	declare	@i int = 1
	while @i <= @n
		begin
		insert @ret values (@i)
		select @i = @i + 1
		end

	return
	end
go

-- exempli gratia ------------------------------------------------------------

/*
	select * from dbo.Seq(0)
	select * from dbo.Seq(4)
	select * from dbo.Seq(-1)
*/
