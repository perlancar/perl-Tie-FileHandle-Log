package Tie::FileHandle::Log;

# DATE
# VERSION

use strict;
use warnings;
use Log::ger;

sub TIEHANDLE {
    my $class = shift;

    my ($mode, $path) = @_;
    log_trace "TIEHANDLE(%s, %s, %s)", $class, $mode, $path;
    open my $fh, $mode, $path or die "Can't open($mode, $path): $!";
    bless {fh=>$fh}, $class;
}

sub WRITE {
    my $this = shift;
    my $res = syswrite $this->{fh}, @_;
    log_trace "WRITE(%s): %s", \@_, $res;
    $res;
}

sub PRINT {
    my $this = shift;
    my $res = print {$this->{fh}} @_;
    log_trace "PRINT(%s): %s", \@_, $res;
    $res;
}

sub PRINTF {
    my $this = shift;
    my $res = printf {$this->{fh}} @_;
    log_trace "PRINTF(%s): %s", \@_, $res;
    $res;
}

sub READ {
    my $this = shift;
    my $scalar = shift;
    my $length = shift;
    my $res;
    if (@_) {
        my $offset = shift;
        $res = read $this->{fh}, $scalar, $length, $offset;
        log_trace "READ(%s, %s, %s): %s", $scalar, $length, $offset, $res;
    } else {
        $res = read $this->{fh}, $scalar, $length;
        log_trace "READ(%s, %s, %s): %s", $scalar, $length, $res;
    }
    $res;
}

sub READLINE {
    my $this = shift;
    my $res = readline $this->{fh};
    log_trace "READLINE(): %s", $res;
    $res;
}

sub GETC {
    my $this = shift;
    my $res = getc $this->{fh};
    log_trace "GETC(): %s", $res;
    $res;
}

sub EOF {
    my ($this, $int) = @_;
    my $res = eof($this->{fh});
    log_trace "EOF(%d): %s", $int, $res;
    $res;
}

sub CLOSE {
    my $this = shift;
    my $res = close $this->{fh};
    log_trace "CLOSE(): %s", $res;
}

sub UNTIE {
    my ($this) = @_;
    log_trace "UNTIE()";
}

# DESTROY

1;
# ABSTRACT: Tied filehandle that logs operations

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Tie::Handle::Log;

 tie *FH, 'Tie::Handle::Log', '>>', 'file.txt';

 # use like you would a regular filehandle
 print FH "one", "two";
 ...
 close FH;


=head1 DESCRIPTION

This class implements tie interface for filehandle but performs normal file
operations and in addition to that logs the operations with L<Log::ger>. It's
basically used for testing, benchmarking, or documentation only.


=head1 SEE ALSO

L<perltie>

L<Log::ger>

L<Tie::Handle::Log> that does nothing except logs.

L<Tie::Scalar::Log>, L<Tie::Array::Log>, L<Tie::Hash::Log>.

L<Tie::Handle>

L<Tie::Simple>

=cut
