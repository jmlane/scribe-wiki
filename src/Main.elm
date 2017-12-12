module Main exposing (Model, Msg, update, view, subscriptions, init)

import Json.Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model False "" (Page "First Page" ""), Cmd.none )


type alias Model =
    { editing : Bool
    , currentContent : String
    , currentPage : Page
    }


type alias Page =
    { title : String
    , content : String
    }


type Msg
    = Edit
    | ContentChanged String
    | Save


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Edit ->
            { model | editing = True } ! [ Cmd.none ]

        ContentChanged newContent ->
            { model | currentContent = newContent } ! [ Cmd.none ]

        Save ->
            let
                currentPage = model.currentPage
                newPage = { currentPage | content = model.currentContent }
            in
                { model | editing = False, currentPage = newPage } ! [ Cmd.none ]


view : Model -> Html Msg
view model =
    section []
        [ h1 [] [ text model.currentPage.title ]
        , viewContent model.editing model.currentPage.content
        , br [] []
        , viewEditButtons model.editing
        ]


viewContent : Bool -> String -> Html Msg
viewContent edit content =
    let
        onChange : (String -> Msg) -> Html.Attribute Msg
        onChange event =
            Html.Events.on "change" <| Json.Decode.map event Html.Events.targetValue
    in
        if edit then
            textarea [ id "content", onChange ContentChanged ] [ text content ]
        else
            p [] [ text content ]


viewEditButtons : Bool -> Html Msg
viewEditButtons edit =
    let
        button =
            if edit then
                Html.button [ onClick Save ] [ text "Save" ]
            else
                Html.button [ onClick Edit ] [ text "Edit" ]
    in
        div [] [ button ]
