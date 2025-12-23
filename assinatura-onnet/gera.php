<?php
require_once 'config.php';
require_once 'partials/header.php';

/* ============================= */
/* ===== FUNÇÕES AUXILIARES ===== */
function sanitize($text) {
    return mb_strtoupper(trim($text), 'UTF-8');
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

/* ============================= */
/* ===== DADOS DO FORMULÁRIO ==== */
$nome     = sanitize($_POST['nome'] ?? '');
$cargo    = sanitize($_POST['cargo'] ?? '');
$telefone = sanitize($_POST['telefone'] ?? '');

if (!$nome || !$cargo || !$telefone) {
    echo "<div class='card'><p style='color:red; text-align:center;'>Preencha todos os campos.</p></div>";
    require_once 'partials/footer.php';
    exit;
}

/* ============================= */
/* ===== ARQUIVOS BASE ========= */
$baseImage = __DIR__ . '/assets/base-gmail.png';
$fontNome  = __DIR__ . '/fontes/Montserrat-Bold.ttf';
$fontCargo = __DIR__ . '/fontes/Montserrat-Regular.ttf';
$fontFone  = __DIR__ . '/fontes/Montserrat-Bold.ttf';
$outputDir = __DIR__ . '/output';

foreach ([$baseImage, $fontNome, $fontCargo, $fontFone] as $file) {
    if (!file_exists($file)) {
        die('Arquivo não encontrado: ' . basename($file));
    }
}

if (!is_dir($outputDir)) {
    mkdir($outputDir, 0777, true);
}

/* ============================= */
/* ===== CRIA IMAGEM ============ */
$image = imagecreatefrompng($baseImage);
imagealphablending($image, true);
imagesavealpha($image, true);

/* ============================= */
/* ===== CORES OFICIAIS ========= */
$verdeNome = imagecolorallocate($image, 0x00, 0x70, 0x40); // #007040
$azulTexto = imagecolorallocate($image, 0x15, 0x45, 0x72); // #154572

/* ============================= */
/* ===== CONTROLE DE POSIÇÃO ==== */
$textX = 470;

/* Nome */
$nomeTop      = 200;
$nomeSize     = 26;
$nomeLineH    = 42;
$nomeMaxWidth = 550;

/* Cargo */
$cargoSize      = 18;
$cargoTopSingle = 260;
$cargoTopMulti  = 284;

/* Telefone */
$foneLeft = 535;
$foneTop  = 332;
$foneSize = 24;

/* ============================= */
/* ===== DESENHA NOME ========== */
$linhasNome = quebraTexto($nome, $fontNome, $nomeSize, $nomeMaxWidth);
$qtdLinhasNome = count($linhasNome);
$yAtual = $nomeTop;

foreach ($linhasNome as $linha) {
    imagettftext($image, $nomeSize, 0, $textX, $yAtual, $verdeNome, $fontNome, $linha);
    $yAtual += $nomeLineH;
}

/* ============================= */
/* ===== DESENHA CARGO ========== */
$yCargo = ($qtdLinhasNome === 1) ? $cargoTopSingle : $cargoTopMulti;
imagettftext($image, $cargoSize, 0, $textX, $yCargo, $azulTexto, $fontCargo, $cargo);

/* ============================= */
/* ===== DESENHA TELEFONE ======= */
imagettftext($image, $foneSize, 0, $foneLeft, $foneTop, $azulTexto, $fontFone, $telefone);

/* ============================= */
/* ===== SALVA IMAGEM =========== */
$nomeArquivo  = preg_replace('/[^A-Z0-9_]/', '_', $nome);
$arquivoFinal = $outputDir . '/' . $nomeArquivo . '_gmail.png';
imagepng($image, $arquivoFinal);

/* ============================= */
/* ===== OUTPUT HTML ============ */
?>

<div class="card">
    <h2>Assinatura Gerada</h2>
    <p>Sua assinatura de e-mail foi criada com sucesso!</p>

    <div class="signature-output">
        <img src="output/<?php echo basename($arquivoFinal); ?>" class="preview" alt="Assinatura">
    </div>

    <!-- Botão destacado para baixar a imagem -->
    <a href="output/<?php echo basename($arquivoFinal); ?>" download>
        <button>Baixar assinatura</button>
    </a>

    <!-- Botão simples para voltar ao formulário -->
    <a href="form.php">
        <button style="margin-top: 10px; background: #f0f0f0; color: #333; border: 1px solid #ccc;">
            Gerar outra assinatura
        </button>
    </a>
</div>

<?php require_once 'partials/footer.php'; ?>
