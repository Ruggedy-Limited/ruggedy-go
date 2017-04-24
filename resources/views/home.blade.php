@extends('layouts.main')
@section ('breadcrumb')
    <button type="button" class="btn round-btn pull-right c-grey" data-toggle="modal" data-target="#help">
        <i class="fa fa-question fa-lg" aria-hidden="true"></i>
    </button>
    {!! Breadcrumbs::render('home') !!}
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
    <div class="row animated fadeIn">
        <div class="col-md-12">
            @can (App\Policies\ComponentPolicy::ACTION_CREATE, new App\Entities\Workspace())
                <a href="{{ route('workspace.create') }}" class="primary-btn" type="button">Add Workspace</a>
            @endcan
        </div>
    </div>

    <div class="row animated fadeIn">
        @if (empty($workspaces))
            <div class="col-sm-12">
                There aren't any workspaces, it's very quiet in here.
                <a href="{{ route('workspace.create') }}">Add a Workspace</a>
            </div>
        @else
            @foreach ($workspaces as $workspace)
                @include('partials.workspace')
            @endforeach
        @endif
    </div>
@endsection
