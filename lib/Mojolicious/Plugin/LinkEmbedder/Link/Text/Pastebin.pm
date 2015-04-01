package Mojolicious::Plugin::LinkEmbedder::Link::Text::Pastebin;

=head1 NAME

Mojolicious::Plugin::LinkEmbedder::Link::Text::Pastebin - pastebin.com link

=head1 DESCRIPTION

This class inherit from L<Mojolicious::Plugin::LinkEmbedder::Link::Text>.

=head1 OUTPUT HTML

This is an example output:

  <pre class="link-embedder text-paste">$txt</pre>

=cut

use Mojo::Base 'Mojolicious::Plugin::LinkEmbedder::Link::Text';

=head1 ATTRIBUTES

=head2 media_id

  $str = $self->media_id;

=cut

has media_id => sub {
  shift->url->path =~ m!^/?(\w+)! ? $1 : '';
};

=head2 provider_name

=cut

sub provider_name {'pastebin.com'}

=head1 METHODS

=head2 learn

=cut

sub learn {
  my ($self, $c, $cb) = @_;
  my $media_id = $self->media_id or return $self->SUPER::learn($c, $cb);
  my $url = Mojo::URL->new('http://pastebin.com/raw.php');

  $self->ua->get(
    $url->query(i => $media_id),
    sub {
      my ($ua, $tx) = @_;
      $self->{text} = $tx->res->body if $tx->success;
      $self->$cb;
    },
  );
}

=head1 AUTHOR

Jan Henning Thorsen

=cut

1;