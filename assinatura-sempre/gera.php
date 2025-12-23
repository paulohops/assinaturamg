<?php
require_once 'config.php';

/* ============================= */
/* ===== CONTROLE DE PREVIEW === */
if (!defined('PREVIEW_MODE')) {
    require_once 'partials/header.php';
}

/* ============================= */
/* ===== FUNÇÕES AUXILIARES ==== */
function sanitize($text) {
    return trim($text);
}

function capitalize($text) {
    return mb_convert_case($text, MB_CASE_TITLE, 'UTF-8');
}

function lowercase($text) {
    return mb_strtolower($text, 'UTF-8');
}

function quebraTexto($texto, $fonte, $tamanho, $maxLargura) {
    $palavras = explode(' ', $texto);
    $linha = '';
    $linhas = [];

    foreach ($palavras as $p) {
        $teste = $linha . $p . ' ';
        $box = imagettfbbox($tamanho, 0, $fonte, $teste);

        if (($box[2] - $box[0]) > $maxLargura) {
            $linhas[] = trim($linha);
            $linha = $p . ' ';
        } else {
            $linha = $teste;
        }
    }

    if (!empty($linha)) {
        $linhas[] = trim($linha);
    }

    return $linhas;
}

function formataTelefone($telefone) {
    // Remove tudo que não for número
    $n = preg_replace('/\D/', '', $telefone);

    if (strlen($n) === 11) {
        return sprintf(
            '(%s) %s %s-%s',
            substr($n, 0, 2),
            substr($n, 2, 1),
            substr($n, 3, 4),
            substr($n, 7, 4)
        );
    }

    return $telefone;
}

/* ============================= */
/* ===== DADOS ================= */
$nome     = capitalize(sanitize($nome ?? $_POST['nome'] ?? ''));
$cargo    = capitalize(sanitize($cargo ?? $_POST['cargo'] ?? ''));
$email    = lowercase(sanitize($email ?? $_POST['email'] ?? ''));
$telefone = lowercase(sanitize($telefone ?? $_POST['telefone'] ?? ''));

$telefone = formataTelefone($telefone);


if (!$nome || !$cargo || !$email || !$telefone) {
    if (!defined('PREVIEW_MODE')) {
        echo "<div class='card'><p style='color:red;text-align:center;'>Preencha todos os campos.</p></div>";
        require_once 'partials/footer.php';
    }
    exit;
}

/* ============================= */
/* ===== ARQUIVOS ============== */
$baseImage   = __DIR__ . '/assets/base-sempre.png';
$fontBold    = __DIR__ . '/fontes/jiho-bold.otf';
$fontRegular = __DIR__ . '/fontes/jiho-light.ttf';
$outputDir   = __DIR__ . '/output';

foreach ([$baseImage, $fontBold, $fontRegular] as $file) {
    if (!file_exists($file)) {
        die('Arquivo não encontrado: ' . basename($file));
    }
}

if (!is_dir($outputDir)) {
    mkdir($outputDir, 0777, true);
}

/* ============================= */
/* ===== CRIA IMAGEM =========== */
$image = imagecreatefrompng($baseImage);
imagealphablending($image, true);
imagesavealpha($image, true);

/* ============================= */
/* ===== CORES ================= */
$branco = imagecolorallocate($image, 255, 255, 255);

/* ================================================= */
/* ===== POSIÇÕES — CONTROLE TOTAL (EDITAR AQUI) ==== */
/* ================================================= */

/* ===== NOME ===== */
$nomeX = 100;
$nomeTop      = 34;
$nomeSize     = 11;
$nomeLineH    = 44;
$nomeMaxWidth = 560;

/* ===== CARGO ===== */
$cargoX   = 100;
$cargoTop = 51;
$cargoSize = 11;

/* ===== EMAIL ===== */
$emailX = 127;
$emailTop = 90;
$emailSize = 11;

/* ===== TELEFONE ===== */
$foneX = 127;
$foneTop = 113;
$foneSize = 11;

/* ===== INSTAGRAM ===== */
$instaX = 127;
$instaTop = 133;
$instaSize = 11;

/* ============================= */
/* ===== DESENHA NOME ========= */
$linhasNome = quebraTexto($nome, $fontBold, $nomeSize, $nomeMaxWidth);
$yAtual = $nomeTop;

foreach ($linhasNome as $linha) {
    imagettftext(
        $image,
        $nomeSize,
        0,
        $nomeX,
        $yAtual,
        $branco,
        $fontBold,
        $linha
    );
    $yAtual += $nomeLineH;
}

/* ============================= */
/* ===== DESENHA CARGO ======== */
imagettftext(
    $image,
    $cargoSize,
    0,
    $cargoX,
    $cargoTop,
    $branco,
    $fontRegular,
    $cargo
);

/* ============================= */
/* ===== DESENHA EMAIL ======== */
imagettftext(
    $image,
    $emailSize,
    0,
    $emailX,
    $emailTop,
    $branco,
    $fontRegular,
    $email
);

/* ============================= */
/* ===== DESENHA TELEFONE ===== */
imagettftext(
    $image,
    $foneSize,
    0,
    $foneX,
    $foneTop,
    $branco,
    $fontRegular,
    $telefone
);


/* ============================= */
/* ===== DESENHA INSTAGRAM ==== */
imagettftext(
    $image,
    $instaSize,
    0,
    $instaX,
    $instaTop,
    $branco,
    $fontRegular,
    '@sempreinternet'
);

/* ============================= */
/* ===== SALVA IMAGEM ========= */
$nomeArquivo  = preg_replace('/[^a-zA-Z0-9]/', '_', $nome);
$arquivoFinal = $outputDir . '/' . $nomeArquivo . '_sempre.png';
imagepng($image, $arquivoFinal);

/* ============================= */
/* ===== PREVIEW ============== */
if (defined('PREVIEW_MODE')) {
    header('Content-Type: image/png');
    readfile($arquivoFinal);
    exit;
}

/* ============================= */
/* ===== OUTPUT HTML ========== */
?>
<div class="card">
    <h2>Assinatura Gerada</h2>
    <p>Sua assinatura foi criada com sucesso.</p>

    <div class="signature-output">
        <img src="output/<?php echo basename($arquivoFinal); ?>" alt="Assinatura">
    </div>

    <a href="output/<?php echo basename($arquivoFinal); ?>" download>
        <button>Baixar assinatura</button>
    </a>

    <a href="form.php">
        <button style="margin-top:10px;background:#f0f0f0;color:#333;border:1px solid #ccc;">
            Gerar outra assinatura
        </button>
    </a>
</div>

<?php
require_once 'partials/footer.php';
