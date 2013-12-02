/*
**	- Synopsis -
**	A (hopefully) better, more flexible and useful rewrite
**	of the system procedure sp_who that ships with SQL Server
**
**	- Syntax -
**	@spid:	requests that more detail be shown about a single
**		process id
**	@cmd:	filters processes given a command
**	@status: filters by status
**	@db:	shows only processes in a given database
**	@user:	shows only processes for a given user name
**	@pgm:	filters by program name
**	@blocked:
**		0 - shows only processes NOT blocked
**		1 - shows only blocked processes
**		null - shows all processes
**	@busy:	shows only processes not awaiting command
**	@sys:	shows only
**		0 - non-system processes
**		1 - system processes
**		null - all processes
**	@tran:	shows only
**		0 - processes NOT in an open transaction
**		1 - processes in open transactions
**		null - all processes
**		
**	- Exempli Gratia -
**	Shows detail for process id 103
**		exec sp_xwho @spid = 103
**	Shows all processes in tempdb
**		exec sp_xwho @db = 'tempdb'
**	Shows only busy processes on the server
**		exec sp_xwho @busy = 1
**	
**	- Marginalia -
**	Author: Erick Calder <e@arix.com>
*/

USE [master]
GO

if object_id('sp_xwho') is not null
	drop proc sp_xwho
go
create proc [dbo].[sp_xwho]
	@spid integer = null
,	@cmd nchar(32) = null
,	@status nchar(60) = null
,	@db sysname = null
,	@user sysname = null
,	@pgm nchar(256) = null
,	@blocked bit = null
,	@busy bit = 0
,	@sys bit = null
,	@tran bit = null
as
	select	p.spid
	,		p.ecid
	,		blk = p.blocked
	,		[tran] = p.open_tran
	,		p.cpu
	,		p.physical_io
	,		p.status
	,		p.cmd
	,		db = db_name(p.dbid)
	,		sql = sql.text
	-- , stmt.start, stmt.[end], stmt.stmt_start, stmt.stmt_end, case when stmt.length > 0 then stmt.length else datalength(sql.text) end
	,		p.program_name
	,		[user] = rtrim(p.loginame) + '@' + rtrim(p.hostname)
	,		p.hostprocess
    -- , sql.*
	from master..sysprocesses p
	outer apply	::fn_get_sql(sql_handle) sql
	where	p.spid != @@spid
	and		p.spid = isnull(@spid, p.spid)
	and		p.cmd = isnull(@cmd, p.cmd)
	and		p.status = isnull(@status, p.status)
	and		p.dbid = isnull(db_id(@db), p.dbid)
	and		p.uid = isnull(user_id(@user), p.uid)
	and		(
			@blocked is null
			or
			(@blocked = 1 and p.blocked > 0)
			or
			(@blocked = 0 and p.blocked = 0)
			)
	and		p.program_name = isnull(@pgm, p.program_name)
	and		( 
            @busy = 0 
            OR 
            p.cmd != 'AWAITING COMMAND' 
            )
    and		(
			@sys is null
			or
			(@sys = 1 and isnull(p.hostname, '') = '')
			or
			(@sys = 0 and isnull(p.hostname, '') != '')
			)
	and		(
			@tran is null
			or
			(@tran = 1 and p.open_tran > 0)
			or
			(@tran = 0 and p.open_tran = 0)
			)
	order	by p.status, p.physical_io -- p.spid, p.ecid
go

