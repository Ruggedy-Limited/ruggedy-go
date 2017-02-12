@extends('layouts.main')

@section('content')

    <div class="animated fadeIn">
        <h5>Breadcrumbs / Goes / Here
            <a data-toggle="modal" data-target="#help">
                <i class="fa fa-question-circle fa-2x pull-right" aria-hidden="true"></i></a>
        </h5>
    </div>
    <!-- Modal -->
    <div id="help" class="modal fade" role="dialog">
        <div class="modal-dialog">

            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Help Ttile</h4>
                </div>
                <div class="modal-body">
                    <p>Help text goes here.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="primary-btn" data-dismiss="modal">Close</button>
                </div>
            </div>

        </div>
    </div>
    <br>
    <div class="row">
        <div class="col-md-6 animated fadeIn">
            <h3>Add Finding</h3>
            <br>
            {!! Form::open(['url' => '/foo/bar']) !!}
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Vulnerability Title') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Status (Open, In Progress, Close)') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Risk Rating') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'CVSS Score') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('description', 'Vulnerability Description') !!}
                {!! Form::textarea('description', null, ['class' => 'black-form-control', 'rows' => '3']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('description', 'Vulnerability Solution') !!}
                {!! Form::textarea('description', null, ['class' => 'black-form-control', 'rows' => '3']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('description', 'Proof of Concept') !!}
                {!! Form::textarea('description', null, ['class' => 'black-form-control', 'rows' => '3']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Screenshot 1') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Screenshot 2') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('vuln_desc.', 'Screenshot 3') !!}
                {!! Form::text('vuln_desc', null, ['class' => 'black-form-control']) !!}
            </div>
            <a href="#" class="border-btn" type="button">Cancel</a>
            <button class="primary-btn" type="submit">Submit</button>
            {!! Form::close() !!}
        </div>
        <div class="col-md-2"></div>
        <div class="col-md-6 animated fadeInUp">

        </div>
    </div>

@endsection