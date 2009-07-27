#!/usr/bin/perl

use Dancer;
use Template;


layout 'main';

before sub {
    var note => "I ARE IN TEH BEFOR FILTERZ";
#    request->path_info('/foo/oversee')
};

get '/foo/*' => sub {
    my ($match) = splat; # ('bar/baz')
    
    use Data::Dumper;

    "note: '".vars->{note}."'\n".
    "match: $match\n".
    "request: ".Dumper(request);
};


get '/' => sub {
    template 'index', {note => vars->{note}};
};

get '/hello/:name' => sub {
    template 'hello';
};

get '/page/:slug' => sub {
    template 'index' => {
        message => 'This is the page '.params->{slug},    
    };
};

post '/new' => sub {
    "creating new entry: ".params->{name};
};

get '/say/:word' => sub {
    if (params->{word} =~ /^\d+$/) {
        pass and return false;
    }
    "I say a word: '".params->{word}."'";
};

get '/download/*.*' => sub { 
    my ($file, $ext) = splat;
    "Downloading $file.$ext";
};

get '/say/:number' => sub {
    pass if (params->{number} == 42); # this is buggy :)
    "I say a number: '".params->{number}."'";
};

# this is the trash route
get r('/(.*)') => sub {
    my ($trash) = splat;
    status 'not_found';
    "got to trash: $trash";
};

Dancer->dance;