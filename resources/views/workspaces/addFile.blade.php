@extends('layouts.main')

@section ('breadcrumb')
    <button type="button" class="btn round-btn pull-right c-grey" data-toggle="modal" data-target="#help">
        <i class="fa fa-question fa-lg" aria-hidden="true"></i>
    </button>
    <a href="{{ route('app.view', [$workspaceApp->getRouteParameterName() => $workspaceApp->getId()]) }}">
        <button type="button" class="btn round-btn pull-right c-yellow">
            <i class="fa fa-times fa-lg" aria-hidden="true"></i>
        </button>
    </a>
    {!! Breadcrumbs::render('dynamic', $workspaceApp) !!}
@endsection

@section('content')
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
            </div>

        </div>
    </div>
    <br>
    <div class="row">
        <div class="col-md-4 col-sm-4 animated fadeIn">
            <h3>Add a {{ ucwords($workspaceApp->getScannerApp()->getName()) }} File</h3>
            <br>
            {!! Form::open([
                'url' => route('file.upload',
                ['workspaceAppId' => $workspaceApp->getId()]),
                'files' => 'true'
            ]) !!}
            <div class="form-group">
                {!! Form::label('name', 'Name') !!}
                {!! Form::text('name', null, ['class' => 'black-form-control']) !!}
            </div>
            <div class="form-group">
                {!! Form::label('description', 'Description') !!}
                {!! Form::textarea('description', null, ['class' => 'black-form-control', 'rows' => '3']) !!}
            </div>
            <div class="form-group">
                {!! Form::label('file', 'Upload File', ['class' => '']) !!}
                {!! Form::file('file') !!}
            </div>
            <button class="primary-btn" type="submit">Submit</button>
            {!! Form::close() !!}
        </div>
        <div class="col-md-2"></div>
        <div class="col-md-6 animated fadeInUp">

        </div>
    </div>

@endsection
