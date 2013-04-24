package MooX::Aliases;
use strictures 1;

our $VERSION = '0.000001';
$VERSION = eval $VERSION;

use Carp;
use Class::Method::Modifiers qw(install_modifier);

sub import {
  my ($class) = @_;
  my $target = caller;

  my $around = do { no strict 'refs'; \&{"${target}::around"} }
    or croak "$target is not a Moo class or role";

  my $make_alias = sub {
    my ($from, $to) = @_;
    no strict 'refs';
    *{"${target}::${from}"} = sub {
      goto $_[0]->can($to);
    };
  };

  my %aliases;
  install_modifier $target, 'around', 'has', sub {
    my $orig = shift;
    my ($attr, %opts) = @_;
    return
      unless $opts{alias};

    my @aliases = ref $opts{alias} ? @{$opts{alias}} : $opts{alias};
    for my $alias (@aliases) {
      $make_alias->($alias => $attr);
    }

    my $name = defined $opts{init_arg} ? $opts{init_arg} : $attr;
    if (!exists $opts{init_arg} || defined $opts{init_arg}) {
      unshift @aliases, $name;
    }
    $aliases{$name} = \@aliases;

    $opts{handle_moose} ||= [];
    push @{ $opts{handle_moose} }, sub {
      require MooseX::Aliases;
    };
    $opts{traits} ||= [];
    push @{ $opts{traits} }, 'MooseX::Aliases::Meta::Trait::Attribute';

    $orig->($attr, %opts);
  };

  $around->('BUILDARGS', sub {
    my $orig = shift;
    my $self = shift;
    my $args = $self->$orig(@_);
    for my $attr (keys %aliases) {
      my @init = grep { exists $args->{$_} } (@{$aliases{$attr}});
      if (@init > 1) {
        croak "Conflicting init_args: (" . join(', ', @init) . ")";
      }
      elsif (@init == 1) {
        $args->{$attr} = delete $args->{$init[0]};
      }
    }
    return $args;
  });

  no strict 'refs';
  *{"${target}::alias"} = $make_alias;
}

1;

__END__

=head1 NAME

MooX::Aliases - easy aliasing of methods and attributes in Moo

=head1 SYNOPSIS

  package MyClass;
  use Moo;
  use MooX::Aliases;

=head1 DESCRIPTION



=head1 SEE ALSO

=over 4

=item L<MooseX::Aliases>

=back

=head1 AUTHOR

haarg - Graham Knop (cpan:HAARG) <haarg@haarg.org>

=head2 CONTRIBUTORS

None so far.

=head1 COPYRIGHT

Copyright (c) 2013 the MooX::Alises L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.

=cut
