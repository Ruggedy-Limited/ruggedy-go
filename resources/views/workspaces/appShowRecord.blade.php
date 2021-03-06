@extends('layouts.main')

@section ('breadcrumb')
    @if ($vulnerability->getFile()->getWorkspaceApp()->isRuggedyApp())
        <a href="{{ route('ruggedy-app.view', [
            $vulnerability->getFile()->getRouteParameterName() => $vulnerability->getFile()->getId()
        ]) }}">
    @else
        <a href="{{ route('file.view', [
            $vulnerability->getFile()->getRouteParameterName() => $vulnerability->getFile()->getId()
        ]) }}">
    @endif
        <button type="button" class="btn round-btn pull-right c-yellow">
            <i class="fa fa-times fa-lg" aria-hidden="true"></i>
        </button>
    </a>
    @if ($vulnerability->getFile()->getWorkspaceApp()->isRuggedyApp())
        <a href="{{ route('vulnerability.delete', [
            $vulnerability->getRouteParameterName() => $vulnerability->getId()
        ]) }}" class="delete-link">
            <button type="button" class="btn round-btn pull-right c-red">
                <i class="fa fa-trash-o fa-lg" aria-hidden="true"></i>
            </button>
        </a>
        <a href="{{ route('vulnerability.edit', [
            $vulnerability->getRouteParameterName() => $vulnerability->getId()
        ]) }}">
            <button type="button" class="btn round-btn pull-right c-purple">
                <i class="fa fa-pencil fa-lg" aria-hidden="true"></i>
            </button>
        </a>
    @endif
    {!! Breadcrumbs::render('dynamic', $vulnerability) !!}
@endsection

@section('content')
    <!-- JIRA -->
    @include('partials.jira-form')
    <!-- Folder -->
    <div id="folder" class="modal fade" role="dialog">
        <div class="modal-dialog">
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">Add to Folder</h4>
                </div>
                <div class="modal-body">
                    {!! Form::open([
                        'url' => route('vulnerability.folder.add', [
                            'vulnerabilityId' => $vulnerability->getId()
                        ])
                    ]) !!}
                        <div class="form-group col-md-12">
                            {!! Form::select('folder-id', $folders) !!}
                        </div>
                        <button class="primary-btn" type="submit">Add to Folder</button>
                    {!! Form::close() !!}
                </div>
            </div>
        </div>
    </div>

    <div class="row animated fadeIn">
        <div class="col-md-12">
            <a href="#" class="primary-btn" type="button" data-toggle="modal" data-target="#jira">Send to JIRA</a>
            @if (!empty($folders))
                @can (App\Policies\ComponentPolicy::ACTION_EDIT, $vulnerability)
                    <a href="#" class="primary-btn" type="button" data-toggle="modal" data-target="#folder">
                        Add to Folder
                    </a>
                @endcan
            @endif
        </div>
    </div>

    <div class="row animated fadeIn {{ $vulnerability->getFile()->getWorkspaceApp()->getScannerApp()->getName() }}">
        <ul class=tabs>
            <li>
                <input type="radio" name="tabs" id="tab1" checked>
                <label for="tab1">
                    <div class="visible-xs mobile-tab">
                        <i class="fa fa-bomb fa-2x" aria-hidden="true"></i><br>
                        <small>Vulnerability</small>
                    </div>
                    <p class="hidden-xs">Vulnerability</p>
                </label>
                <div id="tab-content1" class="tab-content">
                    <div class="dash-line"></div>
                    <div class="col-md-12">
                        <div class="m-t-15">
                            <div class="t-s-14 label label-{{ $vulnerability->getBootstrapAlertCssClass() }} t-s-10">
                                {{ $vulnerability->getSeverityText() }} Risk
                            </div>
                            @if (!empty($vulnerability->getCvssScore()))
                                <div class="m-l-8 t-s-14 label c-grey t-s-10">CVSS
                                    {{ $vulnerability->getCvssScore() }}
                                </div>
                            @endif
                        </div>
                    </div>
                    <div class="col-md-12 m-t-15">
                        <div class="single-content-card">
                            <h4>{{ $vulnerability->getName() }}</h4>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="content-card">
                            {!! $vulnerability->getDescription() !!}
                        </div>
                    </div>
                </div>
            </li>
            <li>
                <input type="radio" name="tabs" id="tab2">
                <label for="tab2">
                    <div class="visible-xs mobile-tab">
                        <i class="fa fa-thumbs-up fa-2x" aria-hidden="true"></i><br>
                        <small>Solution</small>
                    </div>
                    <p class="hidden-xs">Solution</p>
                </label>
                <div id="tab-content2" class="tab-content">
                    <div class="dash-line"></div>
                    <div class="col-md-12">
                        <div class="content-card solution">
                            {!! $vulnerability->getSolution() ?? '<p>No solution available at present.</p>' !!}
                        </div>
                    </div>
                </div>
            </li>
            <li>
                @include('partials.assets-tab', ['tabNo' => 3])
            </li>
            @if (!empty($httpDataCollection) && !$httpDataCollection->isEmpty())
                <li>
                    <input type="radio" name="tabs" id="tab4">
                    <label for="tab4">
                        <div class="visible-xs mobile-tab">
                            <span class="label-count c-grey">
                                {{ $httpDataCollection->total() }}
                            </span>
                            <i class="fa fa-link fa-2x" aria-hidden="true"></i><br>
                            <small>URLs</small>
                        </div>
                        <p class="hidden-xs">
                            URLs
                            <span class="label-count c-grey">
                                {{ $httpDataCollection->total() }}
                            </span>
                        </p>
                    </label>
                    <div id="tab-content4" class="tab-content">
                        <div class="dash-line"></div>
                        <div class="col-md-12">
                            @foreach ($httpDataCollection as $httpData)
                                @include('partials.http-data')
                            @endforeach
                        </div>
                        <div class="col-xs-12">
                            {{ $httpDataCollection->fragment('tab4')->links() }}
                        </div>
                    </div>
                </li>
            @endif
            <li>
                <input type="radio" name="tabs" id="tab5">
                <label for="tab5">
                    <div class="visible-xs mobile-tab">
                        <span class="label-count c-grey">
                            {{ !empty($comments) ? $comments->total() : 0 }}
                        </span>
                        <i class="fa fa-comments fa-2x" aria-hidden="true"></i><br>
                        <small>Comments</small>
                    </div>
                    <p class="hidden-xs">
                        Comments<span class="label-count c-grey">{{ !empty($comments) ? $comments->total() : 0 }}</span>
                    </p>
                </label>
                <div id="tab-content5" class="tab-content">
                    <div class="dash-line"></div>
                    @include('partials.comments')
                </div>
            </li>
        </ul>
        <br style=clear:both;>
    </div>
@endsection
