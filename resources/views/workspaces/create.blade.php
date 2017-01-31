@extends('layouts.main')

@section('content')

    <div class="row">
        <div class="col-md-4 animated fadeIn">
            <h3>Add Workspace</h3>
            <br>
            {!! Form::open(['url' => '/foo/bar']) !!}
            <div class="form-group fg-line">
                {!! Form::label('name', 'Name') !!}
                {!! Form::text('name', null, ['class' => 'red-form-control']) !!}
            </div>
            <div class="form-group fg-line">
                {!! Form::label('description', 'Description') !!}
                {!! Form::textarea('description', null, ['class' => 'red-form-control', 'rows' => '3']) !!}
            </div>
            <button class="primary-btn" type="submit">Submit</button>
            {!! Form::close() !!}
        </div>
        <div class="col-md-2"></div>
        <div class="col-md-6 animated fadeInUp">
            <div class="white-content-card">
                <h4 class="h-4-1 t-c-red">Creating a Workspace</h4>
                <p>Pellentesque lacinia sagittis libero. Praesent vitae justo purus. In hendrerit lorem nisl, ac
                    lacinia urna aliquet non. Quisque nisi tellus, rhoncus quis est s, rhoncus quis est s,
                    rhoncus quis est s, rhoncus quis est s, rhoncus quis est s, rhoncus quis est</p>
            </div>
        </div>
    </div>

@endsection