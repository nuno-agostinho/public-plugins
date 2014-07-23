=head1 LICENSE

Copyright [1999-2014] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Component::Tools::AssemblyConverter::TicketsList;

use strict;
use warnings;

use parent qw(
  EnsEMBL::Web::Component::Tools::AssemblyConverter
  EnsEMBL::Web::Component::Tools::TicketsList
);

sub job_summary_section {
  ## @override
  my ($self, $ticket, $job, $hit_count) = @_;

  my $summary = $self->SUPER::job_summary_section($ticket, $job, $hit_count);
  my $desc    = $job->job_data->{'summary'};

  ## Assembly converter doesn't have a results page - instead, attach this file to the browser
  my @results_links = @{$summary->get_nodes_by_flag('job_results_link')||[]};
  
  my $location = $self->hub->param('r') || $self->hub->species_defs->SAMPLE_DATA->{'LOCATION_PARAM'};
  foreach (@results_links) {
    $summary->insert_before({
                          'node_name'   => 'a',
                          'inner_HTML'  => '[View in browser]',
                          'class'       => [qw(small left-margin)],
                          'href'        => $self->hub->url({
                                              'species'   => $job->species,
                                              'type'      => 'Location',
                                              'action'    => 'View',
                                              'function'  => '',
                                              'r'         => $location,
                                            }),
                  }, $_);
  }
  $_->parent_node->remove_child($_) for @{$summary->get_nodes_by_flag('job_results_link')};

  return $summary;
}

sub ticket_buttons {
  my ($self, $ticket) = @_;
  my $buttons   = $self->SUPER::ticket_buttons($ticket);
  my $url_param = $self->object->create_url_param({'ticket_name' => $ticket->ticket_name});

  $buttons->prepend_child({
                      'node_name'   => 'a',
                      'class'       => [qw(_download)],
                      'href'        => $self->hub->url({
                                              'type'      => 'Download',
                                              'action'    => 'AssemblyConverter', 
                                              'function'  => '', 
                                              'tl'        => $url_param,
                                        }),
                      'children'    => [{
                                        'node_name' => 'span',
                                        'class'     => [qw(_ht sprite download_icon)],
                                        'title'     => 'Download output file'
                                        }],
   
                      });

  return $buttons;
}

1;
