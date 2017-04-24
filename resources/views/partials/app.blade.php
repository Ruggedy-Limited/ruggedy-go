<div class="col-md-4 col-sm-6">
    @if ($app->isRuggedyApp())
        <a href="{{ route('ruggedy-app.view', ['fileId' => $app->getFiles()->first()->getId()]) }}">
    @else
        <a href="{{ route('app.view', ['workspaceAppId' => $app->getId()]) }}">
    @endif
        <div class="card hovercard animated pulse-hover">
            <div class="cardheader c-white">
            </div>
            <div class="avatar avatar-white">
                <img src="{{ $app->getScannerApp()->getLogo() }}">
            </div>
            <div class="info">
                <div class="title h-3">
                    <h4>{{ $app->getName() }}</h4>
                </div>
                <div class="desc t-3">
                    {{ $app->getDescription() }}
                </div>
            </div>
        </div>
    </a>
</div>