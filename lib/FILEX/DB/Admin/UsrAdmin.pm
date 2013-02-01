package FILEX::DB::Admin::UsrAdmin;
use strict;
use vars qw($VERSION @ISA);
use FILEX::DB::base 1.0;

# inherit FILEX::DB::base
@ISA = qw(FILEX::DB::base);
$VERSION = 1.0;

# list users
sub listUsers {
	my $self = shift;
	my $res = shift;
	return undef if (ref($res) ne "ARRAY");
	my $dbh = $self->_dbh();
	my $strQuery = "SELECT * FROM usr_admin ORDER BY uid";
	eval {
		my $sth = $dbh->prepare($strQuery);
		$sth->execute();
		while ( my $row = $sth->fetchrow_hashref() ) {
			push(@$res,$row);
		}
		$sth->finish();
	};
	if ($@) {
		$self->setLastError(query=>$strQuery,string=>$dbh->errstr(),code=>$dbh->err());
		warn(__PACKAGE__,"-> Database Error : $@ : $strQuery");
		return undef;
	}
	return 1;
}

# add user
# require a username
sub addUser {
	my $self = shift;
	my $uname = shift;
	my $dbh = $self->_dbh();
	$uname = $self->_dbh->quote($uname);
	my $strQuery = "INSERT INTO usr_admin (uid) VALUES ($uname)";
	my ($res,$sth);
	eval {
		$sth = $dbh->prepare($strQuery);
		$res = $sth->execute();
		$dbh->commit();
	};
	if ($@) {
		$self->setLastError(query=>$strQuery,string=>$dbh->errstr(),code=>$dbh->err());
		warn(__PACKAGE__,"-> Database Error : $@ : $strQuery");
		return undef;
	}
	return 1;
}

# delete user
# require an id
sub delUser {
	my $self = shift;
	my $id = shift;
	my $dbh = $self->_dbh();
	my $strQuery = "DELETE FROM usr_admin WHERE id=$id";
	my ($res,$sth);
	eval {
		$sth = $dbh->prepare($strQuery);
		$res = $sth->execute();
		$dbh->commit();
	};
	if ($@) {
		$self->setLastError(query=>$strQuery,string=>$dbh->errstr(),code=>$dbh->err());
		warn(__PACKAGE__,"-> Database Error : $@ : $strQuery");
		return undef;
	}
	return 1;
}

# set enable flag
# require an id
# require 0|1
sub setEnable {
	my $self = shift;
	my $id = shift;
	my $enable = shift;
	my $dbh = $self->_dbh();
	my $strQuery = "UPDATE usr_admin SET enable=$enable WHERE id=$id";
	my ($res,$sth);
	eval {
		$sth = $dbh->prepare($strQuery);
		$res = $sth->execute();
		$dbh->commit();
	};
	if ($@) {
		$self->setLastError(query=>$strQuery,string=>$dbh->errstr(),code=>$dbh->err());
		warn(__PACKAGE__,"-> Database Error : $@ : $strQuery");
		return undef;
	}
	return 1;
}

1;
=pod

=head1 AUTHOR AND COPYRIGHT

FileX - a web file exchange system.

Copyright (c) 2004-2005 Olivier FRANCO

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; see the file COPYING . If not, write to the
Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=cut
