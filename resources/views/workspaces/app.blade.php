<?php
/**
 * @var App\Entities\File $file
 */
?>
@extends('layouts.main')

@section ('breadcrumb')
    <a href="{{ route('workspace.view', [
        $workspaceApp->getWorkspace()->getRouteParameterName() => $workspaceApp->getWorkspace()->getId()
    ]) }}">
        <button type="button" class="btn round-btn pull-right c-yellow">
            <i class="fa fa-times fa-lg" aria-hidden="true"></i>
        </button>
    </a>
    @can (App\Policies\ComponentPolicy::ACTION_EDIT, $workspaceApp)
        <a href="{{ route('app.delete', [
            'workspaceId'    => $workspaceApp->getWorkspace()->getId(),
            'workspaceAppId' => $workspaceApp->getId()
        ]) }}" class="delete-link">
            <button type="button" class="btn round-btn pull-right c-red">
                <i class="fa fa-trash-o fa-lg" aria-hidden="true"></i>
            </button>
        </a>
        <a href="{{ route('app.edit', [$workspaceApp->getRouteParameterName() => $workspaceApp->getId()]) }}">
            <button type="button" class="btn round-btn pull-right c-purple">
                <i class="fa fa-pencil fa-lg" aria-hidden="true"></i>
            </button>
        </a>
    @endcan
    {!! Breadcrumbs::render('dynamic', $workspaceApp) !!}
@endsection

@section('content')
    <div class="row animated fadeIn">
        <div class="col-md-12">
            @can (App\Policies\ComponentPolicy::ACTION_CREATE, $workspaceApp)
            <a href="{{ route('file.create', ['workspaceAppId' => $workspaceApp->getId()]) }}"
               class="primary-btn" type="button">Add File</a>
            @endcan
        </div>
    </div>
    <div class="row animated fadeIn">
        <ul class=tabs>
            <li>
                <input type="radio" name="tabs" id="tab1" checked>
                <label for="tab1">
                    <div class="visible-xs mobile-tab">
                        <span class="label-count c-grey">
                            {{ !empty($files) ? $files->total() : 0 }}
                        </span>
                        <i class="fa fa-file fa-2x" aria-hidden="true"></i><br>
                        <small>Files</small>
                    </div>
                    <p class="hidden-xs">
                        Files<span class="label-count c-grey">{{ !empty($files) ? $files->total() : 0 }}</span>
                    </p>
                </label>
                <div id="tab-content1" class="tab-content">
                    <div class="dash-line"></div>
                    <div>
                        <div>
                            @if (empty($files) || $files->isEmpty())
                                <br>
                                <div class="col-xs-12">
                                <p class="p-l-8">
                                    You haven't uploaded any {{ ucwords($workspaceApp->getScannerApp()->getName()) }}
                                    files yet.
                                    <a href="{{ route('file.create', ['workspaceAppId' => $workspaceApp->getId()]) }}">
                                        Upload one now?
                                    </a>
                                </p>
                                </div>
                            @else
                                <div class="row">
                                    @foreach($files as $file)
                                        <div class="col-md-4 animated pulse-hover">
                                            <div class="convenience-buttons">
                                                @can (App\Policies\ComponentPolicy::ACTION_EDIT, $file)
                                                    <a href="{{ route('file.delete', [
                                                            $file->getRouteParameterName()                    => $file->getId(),
                                                            $file->getWorkspaceApp()->getRouteParameterName() => $file->getWorkspaceApp()->getId()
                                                        ]) }}" class="delete-link">
                                                        <button type="button" class="btn round-btn pull-right c-red">
                                                            <i class="fa fa-trash-o fa-lg" aria-hidden="true"></i>
                                                        </button>
                                                    </a>
                                                    <a href="{{ route('file.edit', [$file->getRouteParameterName() => $file->getId()]) }}">
                                                        <button type="button" class="btn round-btn pull-right c-purple">
                                                            <i class="fa fa-pencil fa-lg" aria-hidden="true"></i>
                                                        </button>
                                                    </a>
                                                @endcan
                                            </div>
                                            <a href="{{ route('file.view', ['fileId' => $file->getId()]) }}">
                                                <div class="file-card">
                                                    <div class="img-float">
                                                    <i class="fa fa-file-text-o fa-3x" aria-hidden="true"></i>
                                                    </div>
						    <h4 class="h-4-1">{{ $file->getName() }}</h4>
                                                    <p>{{ $file->getDescription() }}</p>
                                                </div>
                                            </a>
                                        </div>
                                    @endforeach
                                </div>
                                <div class="row">
                                    {{ $files->fragment('tab1')->links() }}
                                </div>
                            @endif
                        </div>
                    </div>
                </div>
            </li>
        </ul>
        <br style=clear:both;>
    </div>
@endsection
