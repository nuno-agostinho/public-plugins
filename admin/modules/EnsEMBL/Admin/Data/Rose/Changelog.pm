package EnsEMBL::Admin::Data::Rose::Changelog;

### NAME: EnsEMBL::Admin::Data::Rose::Changelog;
### Wrapper for one or more EnsEMBL::Admin::Rose::Object::Changelog objects

### STATUS: Under Development

### DESCRIPTION:

use strict;
use warnings;
no warnings qw(uninitialized);

use EnsEMBL::Admin::Rose::Manager::Changelog;
use base qw(EnsEMBL::ORM::Data::Rose);

sub set_primary_keys {
  my $self = shift;
  $self->{'_primary_keys'} = [qw(changelog_id)];
}

sub set_classes {
### Set custom class names, as we're using the plugin namespace 
  my $self = shift;
  $self->{'_object_class'} = 'EnsEMBL::Admin::Rose::Object::Changelog';
  $self->{'_manager_class'} = 'EnsEMBL::Admin::Rose::Manager::Changelog';
}

sub fetch_all {
### Custom query - for the changelog output, we normally only want to 
### see the results for one release at a time
  my $self = shift;
  my $release_id = $self->hub->param('release') 
                      || $self->hub->species_defs->ENSEMBL_VERSION;

  my $objects = EnsEMBL::Admin::Rose::Manager::Changelog->get_changelogs(
    with_objects => 'species',
    query => [
      release_id => $release_id,
    ],
    sort_by => 'team',
  );
  $self->data_objects(@$objects);
  return $objects;
}

1;
